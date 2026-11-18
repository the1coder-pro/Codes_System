[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
    [string]$DatabasePath,

    [string]$OutputPath = (Join-Path (Get-Location) "legacy-access-export.zip")
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Data
Add-Type -AssemblyName System.IO.Compression

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$schemaManifestPath = Join-Path `
    $projectRoot `
    "artifacts\accounting\flutter_app\migration\legacy_schema_manifest.json"
$schemaManifest = Get-Content -LiteralPath $schemaManifestPath -Raw -Encoding UTF8 |
    ConvertFrom-Json
$expectedTables = @($schemaManifest.tables)

if ($expectedTables.Count -eq 0) {
    throw "The legacy schema manifest contains no tables."
}

$resolvedDatabasePath = (Resolve-Path -LiteralPath $DatabasePath).Path
$resolvedOutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$outputDirectory = [System.IO.Path]::GetDirectoryName($resolvedOutputPath)
[System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
if (Test-Path -LiteralPath $resolvedOutputPath) {
    throw "The output file already exists. Choose a new -OutputPath: $resolvedOutputPath"
}

function ConvertTo-CsvField {
    param([AllowNull()][object]$Value)

    if ($null -eq $Value -or $Value -is [System.DBNull]) {
        $text = "\N"
    }
    elseif ($Value -is [byte[]]) {
        $text = "base64:" + [Convert]::ToBase64String($Value)
    }
    elseif ($Value -is [datetime]) {
        $text = $Value.ToString(
            "yyyy-MM-ddTHH:mm:ss.fffffff",
            [Globalization.CultureInfo]::InvariantCulture
        )
    }
    elseif ($Value -is [bool]) {
        $text = if ($Value) { "1" } else { "0" }
    }
    elseif ($Value -is [string]) {
        $text = $Value
        if ($text.StartsWith("\", [StringComparison]::Ordinal)) {
            # A leading escape distinguishes literal text such as "\N" from NULL.
            $text = "\" + $text
        }
    }
    else {
        $text = [Convert]::ToString(
            $Value,
            [Globalization.CultureInfo]::InvariantCulture
        )
    }

    return '"' + $text.Replace('"', '""') + '"'
}

function Get-AccessConnection {
    param([string]$Path)

    $lastError = $null
    foreach ($provider in @("Microsoft.ACE.OLEDB.16.0", "Microsoft.ACE.OLEDB.12.0")) {
        $builder = New-Object System.Data.OleDb.OleDbConnectionStringBuilder
        $builder["Provider"] = $provider
        $builder["Data Source"] = $Path
        $builder["Persist Security Info"] = $false
        $connection = [System.Data.OleDb.OleDbConnection]::new(
            $builder.ConnectionString
        )
        try {
            $connection.Open()
            return $connection
        }
        catch {
            $lastError = $_
            $connection.Dispose()
        }
    }

    throw (
        "Could not open the Access database with the Microsoft ACE driver. " +
        "Install the Microsoft Access Database Engine matching this PowerShell " +
        "process's architecture, then retry. Details: " +
        $lastError.Exception.Message
    )
}

function Write-ZipTextEntry {
    param(
        [System.IO.Compression.ZipArchive]$Archive,
        [string]$Name,
        [string]$Content
    )

    $entry = $Archive.CreateEntry(
        $Name,
        [System.IO.Compression.CompressionLevel]::Optimal
    )
    $stream = $entry.Open()
    $writer = [System.IO.StreamWriter]::new(
        $stream,
        [System.Text.UTF8Encoding]::new($false)
    )
    try {
        $writer.Write($Content)
    }
    finally {
        $writer.Dispose()
    }
}

$connection = $null
$archive = $null
$outputStream = $null
$completed = $false
$rowCounts = [ordered]@{}
$utf8 = [System.Text.UTF8Encoding]::new($false)

try {
    $connection = Get-AccessConnection -Path $resolvedDatabasePath
    $accessTables = $connection.GetOleDbSchemaTable(
        [System.Data.OleDb.OleDbSchemaGuid]::Tables,
        $null
    )
    $availableNames = [System.Collections.Generic.HashSet[string]]::new(
        [StringComparer]::Ordinal
    )
    foreach ($row in $accessTables.Rows) {
        if (
            $row["TABLE_TYPE"] -eq "TABLE" -and
            -not ([string]$row["TABLE_NAME"]).StartsWith(
                "MSys",
                [StringComparison]::OrdinalIgnoreCase
            )
        ) {
            [void]$availableNames.Add([string]$row["TABLE_NAME"])
        }
    }

    $missingTables = @(
        $expectedTables |
            Where-Object { -not $availableNames.Contains([string]$_.name) }
    )
    if ($missingTables.Count -gt 0) {
        throw (
            "The Access database is missing " + $missingTables.Count +
            " tables from the legacy schema. No export was kept."
        )
    }

    $outputStream = [System.IO.File]::Open(
        $resolvedOutputPath,
        [System.IO.FileMode]::CreateNew,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None
    )
    $archive = [System.IO.Compression.ZipArchive]::new(
        $outputStream,
        [System.IO.Compression.ZipArchiveMode]::Create,
        $false
    )

    foreach ($table in $expectedTables) {
        $tableName = [string]$table.name
        if (
            [string]::IsNullOrWhiteSpace($tableName) -or
            $tableName.Contains("/") -or
            $tableName.Contains("\")
        ) {
            throw "Unsupported table name in schema manifest; export stopped."
        }

        $quotedTable = "[" + $tableName.Replace("]", "]]") + "]"
        $command = $connection.CreateCommand()
        $command.CommandText = "SELECT * FROM $quotedTable"
        $reader = $null
        $writer = $null
        try {
            $reader = $command.ExecuteReader()
            $actualColumns = @(
                for ($index = 0; $index -lt $reader.FieldCount; $index++) {
                    $reader.GetName($index)
                }
            )
            $expectedColumns = @($table.columns | ForEach-Object { [string]$_.name })
            if ($actualColumns.Count -ne $expectedColumns.Count) {
                throw "Column count differs for legacy table $tableName. Export stopped."
            }
            for ($index = 0; $index -lt $expectedColumns.Count; $index++) {
                if ($actualColumns[$index] -cne $expectedColumns[$index]) {
                    throw "Column names or order differ for legacy table $tableName. Export stopped."
                }
            }

            $entry = $archive.CreateEntry(
                "$tableName.csv",
                [System.IO.Compression.CompressionLevel]::Optimal
            )
            $entryStream = $entry.Open()
            $writer = [System.IO.StreamWriter]::new($entryStream, $utf8)

            $header = @(
                $actualColumns | ForEach-Object { ConvertTo-CsvField $_ }
            ) -join ","
            $writer.WriteLine($header)

            [long]$rowCount = 0
            while ($reader.Read()) {
                $values = [string[]]::new($reader.FieldCount)
                for ($index = 0; $index -lt $reader.FieldCount; $index++) {
                    $values[$index] = ConvertTo-CsvField $reader.GetValue($index)
                }
                $writer.WriteLine(($values -join ","))
                $rowCount++
            }
            $rowCounts[$tableName] = $rowCount
            Write-Host "Exported $tableName ($rowCount rows)"
        }
        finally {
            if ($writer) {
                $writer.Dispose()
            }
            if ($reader) {
                $reader.Dispose()
            }
            $command.Dispose()
        }
    }

    $metadata = [ordered]@{
        formatVersion = 1
        tableCount = $expectedTables.Count
        nullMarker = "\N"
        escapeRule = "Text values beginning with backslash have one extra leading backslash."
        dateTimeFormat = "yyyy-MM-ddTHH:mm:ss.fffffff"
        binaryFormat = "base64:"
        rowCounts = $rowCounts
    } | ConvertTo-Json -Depth 5
    Write-ZipTextEntry -Archive $archive -Name "_export_manifest.json" -Content $metadata
    $completed = $true
}
finally {
    if ($archive) {
        $archive.Dispose()
    }
    elseif ($outputStream) {
        $outputStream.Dispose()
    }
    if ($connection) {
        $connection.Dispose()
    }
    if (-not $completed -and (Test-Path -LiteralPath $resolvedOutputPath)) {
        Remove-Item -LiteralPath $resolvedOutputPath -Force
    }
}

Write-Host "Export complete: $resolvedOutputPath"
Write-Host "No source records were changed. The archive includes explicit NULL markers."
