package com.codes.migration;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public final class AccessCsvExporter {
    private static final String NULL_MARKER = "\\N";
    private static final String ESCAPE_PREFIX = "\\";
    private static final ObjectMapper JSON = new ObjectMapper();

    private AccessCsvExporter() {
    }

    public static void main(String[] args) throws Exception {
        Path databasePath = requiredEnvironmentPath("ACCESS_DB_PATH");
        Path outputPath = requiredEnvironmentPath("ACCESS_EXPORT_PATH");
        Path manifestPath = requiredEnvironmentPath("LEGACY_SCHEMA_MANIFEST");
        export(databasePath, outputPath, manifestPath);
    }

    private static Path requiredEnvironmentPath(String name) {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing required environment setting: " + name);
        }
        return Paths.get(value).toAbsolutePath().normalize();
    }

    static void export(Path databasePath, Path outputPath, Path manifestPath) throws Exception {
        if (!Files.isRegularFile(databasePath)) {
            throw new IllegalArgumentException("Access database file was not found.");
        }
        if (!Files.isRegularFile(manifestPath)) {
            throw new IllegalArgumentException("Legacy schema manifest was not found.");
        }
        if (databasePath.toString().contains(";")) {
            throw new IllegalArgumentException(
                    "Move the Access file to a path without semicolons, then retry.");
        }
        if (Files.exists(outputPath)) {
            throw new IllegalArgumentException("Output already exists; choose another path.");
        }

        List<TableSpec> expectedTables = readSchema(manifestPath);
        if (expectedTables.isEmpty()) {
            throw new IllegalArgumentException("The schema manifest contains no tables.");
        }

        Path parent = outputPath.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }
        Path temporaryOutput = outputPath.resolveSibling(
                outputPath.getFileName() + ".partial-" + UUID.randomUUID());
        boolean completed = false;

        try (Connection connection = openReadOnlyAccess(databasePath)) {
            validateTables(connection, expectedTables);
            Map<String, Long> rowCounts = new LinkedHashMap<>();
            try (OutputStream file = Files.newOutputStream(
                    temporaryOutput,
                    StandardOpenOption.CREATE_NEW,
                    StandardOpenOption.WRITE);
                 ZipOutputStream zip = new ZipOutputStream(file, StandardCharsets.UTF_8)) {

                for (TableSpec table : expectedTables) {
                    long count = exportTable(connection, zip, table);
                    rowCounts.put(table.name, count);
                    System.out.println("Exported " + table.name + " (" + count + " rows)");
                }
                writeManifest(zip, expectedTables.size(), rowCounts);
            }

            try {
                Files.move(temporaryOutput, outputPath, StandardCopyOption.ATOMIC_MOVE);
            } catch (AtomicMoveNotSupportedException unsupported) {
                Files.move(temporaryOutput, outputPath);
            }
            completed = true;
        } finally {
            if (!completed) {
                Files.deleteIfExists(temporaryOutput);
            }
        }

        System.out.println("Export complete: " + outputPath);
        System.out.println("The source database was opened read-only; no records were changed.");
    }

    private static Connection openReadOnlyAccess(Path databasePath) throws Exception {
        String path = databasePath.toString().replace('\\', '/');
        String url = "jdbc:ucanaccess://" + path;
        Connection connection = DriverManager.getConnection(url);
        connection.setReadOnly(true);
        return connection;
    }

    private static List<TableSpec> readSchema(Path manifestPath) throws IOException {
        JsonNode root = JSON.readTree(manifestPath.toFile());
        JsonNode tablesNode = root.path("tables");
        if (!tablesNode.isArray()) {
            throw new IllegalArgumentException("The schema manifest has no tables array.");
        }
        List<TableSpec> tables = new ArrayList<>();
        for (JsonNode tableNode : tablesNode) {
            String name = tableNode.path("name").asText();
            if (name.isEmpty() || name.contains("/") || name.contains("\\")) {
                throw new IllegalArgumentException("The manifest contains an unsafe table name.");
            }
            List<String> columns = new ArrayList<>();
            JsonNode columnsNode = tableNode.path("columns");
            if (!columnsNode.isArray()) {
                throw new IllegalArgumentException("The manifest has an invalid column list.");
            }
            for (JsonNode columnNode : columnsNode) {
                columns.add(columnNode.path("name").asText());
            }
            tables.add(new TableSpec(name, columns));
        }
        return tables;
    }

    private static void validateTables(Connection connection, List<TableSpec> tables)
            throws Exception {
        Set<String> actualNames = new HashSet<>();
        DatabaseMetaData metadata = connection.getMetaData();
        try (ResultSet rows = metadata.getTables(null, null, "%", new String[]{"TABLE"})) {
            while (rows.next()) {
                String name = rows.getString("TABLE_NAME");
                if (name != null && !name.regionMatches(true, 0, "MSys", 0, 4)) {
                    actualNames.add(name);
                }
            }
        }
        List<String> missing = new ArrayList<>();
        for (TableSpec table : tables) {
            if (!actualNames.contains(table.name)) {
                missing.add(table.name);
            }
        }
        if (!missing.isEmpty()) {
            throw new IllegalArgumentException(
                    "The Access database is missing " + missing.size()
                            + " exact legacy table names. No export was kept.");
        }
    }

    private static long exportTable(
            Connection connection,
            ZipOutputStream zip,
            TableSpec table) throws Exception {
        String sqlName = table.name.replace("]", "]]");
        String sql = "SELECT * FROM [" + sqlName + "]";
        zip.putNextEntry(new ZipEntry(table.name + ".csv"));
        long count = 0;

        try (Statement statement = connection.createStatement(
                ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
             ResultSet rows = statement.executeQuery(sql)) {
            ResultSetMetaData metadata = rows.getMetaData();
            if (metadata.getColumnCount() != table.columns.size()) {
                throw new IllegalArgumentException(
                        "Column count differs for legacy table " + table.name + ".");
            }
            for (int index = 0; index < table.columns.size(); index++) {
                String actual = metadata.getColumnName(index + 1);
                if (!table.columns.get(index).equals(actual)) {
                    throw new IllegalArgumentException(
                            "Column names or order differ for legacy table "
                                    + table.name + ".");
                }
            }

            BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(zip, StandardCharsets.UTF_8));
            for (int column = 0; column < table.columns.size(); column++) {
                if (column > 0) {
                    writer.write(',');
                }
                writer.write(csvCell(table.columns.get(column), false));
            }
            writer.write('\n');

            while (rows.next()) {
                for (int column = 0; column < table.columns.size(); column++) {
                    if (column > 0) {
                        writer.write(',');
                    }
                    writer.write(csvCell(rows.getObject(column + 1), true));
                }
                writer.write('\n');
                count++;
            }
            writer.flush();
        }
        zip.closeEntry();
        return count;
    }

    static String csvCell(Object value, boolean escapeText) throws Exception {
        if (value == null) {
            return quoteCsv(NULL_MARKER);
        }

        String text;
        if (value instanceof byte[]) {
            text = "base64:" + Base64.getEncoder().encodeToString((byte[]) value);
        } else if (value instanceof Blob) {
            Blob blob = (Blob) value;
            int length = Math.toIntExact(blob.length());
            text = "base64:" + Base64.getEncoder().encodeToString(blob.getBytes(1, length));
        } else if (value instanceof Timestamp) {
            LocalDateTime dateTime = ((Timestamp) value).toLocalDateTime();
            text = DateTimeFormatter.ISO_LOCAL_DATE_TIME.format(dateTime);
        } else if (value instanceof java.sql.Date) {
            text = ((java.sql.Date) value).toLocalDate().toString();
        } else if (value instanceof java.sql.Time) {
            text = ((java.sql.Time) value).toLocalTime().toString();
        } else if (value instanceof Boolean) {
            text = (Boolean) value ? "1" : "0";
        } else if (value instanceof java.math.BigDecimal) {
            text = ((java.math.BigDecimal) value).toPlainString();
        } else {
            text = String.valueOf(value);
        }

        if (escapeText && value instanceof String && text.startsWith(ESCAPE_PREFIX)) {
            text = ESCAPE_PREFIX + text;
        }
        return quoteCsv(text);
    }

    private static String quoteCsv(String value) {
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }

    private static void writeManifest(
            ZipOutputStream zip,
            int tableCount,
            Map<String, Long> rowCounts) throws IOException {
        Map<String, Object> manifest = new LinkedHashMap<>();
        manifest.put("formatVersion", 1);
        manifest.put("tableCount", tableCount);
        manifest.put("nullMarker", NULL_MARKER);
        manifest.put("escapeRule",
                "Text values beginning with backslash have one extra leading backslash.");
        manifest.put("dateTimeFormat", "ISO-8601 local date/time");
        manifest.put("binaryFormat", "base64:");
        manifest.put("rowCounts", rowCounts);

        zip.putNextEntry(new ZipEntry("_export_manifest.json"));
        byte[] data = JSON.writerWithDefaultPrettyPrinter().writeValueAsBytes(manifest);
        zip.write(data);
        zip.write('\n');
        zip.closeEntry();
    }

    private static final class TableSpec {
        private final String name;
        private final List<String> columns;

        private TableSpec(String name, List<String> columns) {
            this.name = name;
            this.columns = columns;
        }
    }
}
