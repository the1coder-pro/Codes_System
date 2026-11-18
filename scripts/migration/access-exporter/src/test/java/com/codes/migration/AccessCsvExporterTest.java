package com.codes.migration;

import io.github.spannm.jackcess.ColumnBuilder;
import io.github.spannm.jackcess.DataType;
import io.github.spannm.jackcess.Database;
import io.github.spannm.jackcess.DatabaseBuilder;
import io.github.spannm.jackcess.Table;
import io.github.spannm.jackcess.TableBuilder;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import static org.junit.jupiter.api.Assertions.assertTrue;

class AccessCsvExporterTest {
    @TempDir
    Path temporaryDirectory;

    @Test
    void exportSeparatesNullEmptyTextAndEscapedMarker() throws Exception {
        Path databasePath = temporaryDirectory.resolve("legacy sample.accdb");
        Path manifestPath = temporaryDirectory.resolve("schema.json");
        Path outputPath = temporaryDirectory.resolve("export.zip");

        Database database = DatabaseBuilder.create(
                Database.FileFormat.V2010, databasePath.toFile());
        try {
            Table sample = new TableBuilder("tblSample")
                    .addColumn(new ColumnBuilder("ID", DataType.LONG))
                    .addColumn(new ColumnBuilder("Name", DataType.TEXT).withMaxLength())
                    .addColumn(new ColumnBuilder("EventDate", DataType.SHORT_DATE_TIME))
                    .toTable(database);
            Date date = new Date(1763467200000L);
            sample.addRow(1, null, date);
            sample.addRow(2, "", date);
            sample.addRow(3, "\\N", date);
            sample.addRow(4, "مرحبا", date);
        } finally {
            database.close();
        }

        String manifest = "{\"tables\":[{\"name\":\"tblSample\",\"columns\":["
                + "{\"name\":\"ID\"},{\"name\":\"Name\"},{\"name\":\"EventDate\"}]}]}";
        Files.write(manifestPath, manifest.getBytes(StandardCharsets.UTF_8));

        AccessCsvExporter.export(databasePath, outputPath, manifestPath);

        try (ZipFile zip = new ZipFile(outputPath.toFile(), StandardCharsets.UTF_8)) {
            ZipEntry csvEntry = zip.getEntry("tblSample.csv");
            assertTrue(csvEntry != null);
            String csv = new String(
                    zip.getInputStream(csvEntry).readAllBytes(),
                    StandardCharsets.UTF_8);
            assertTrue(csv.contains("\"1\",\"\\N\","));
            assertTrue(csv.contains("\"2\",\"\","));
            assertTrue(csv.contains("\"3\",\"\\\\N\","));
            assertTrue(csv.contains("\"4\",\"مرحبا\","));
            assertTrue(csv.contains("2025-11-18T"));
            assertTrue(zip.getEntry("_export_manifest.json") != null);
        }
    }
}
