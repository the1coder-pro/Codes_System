import 'dart:convert';
import 'dart:io';

import 'package:accounting_ui/local_printer_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const token = 'a-pairing-token-that-is-long-enough-for-tests-123456';

  test(
    'local service requires pairing and routes a PDF to the chosen printer',
    () async {
      PrinterDevice? printedOn;
      String? printedJob;
      final service = LocalPrinterHttpService(
        token: token,
        port: 0,
        listPrinters: () async => const [
          PrinterDevice(
            name: 'Invoice printer',
            displayName: 'Invoice printer',
            description: '',
            isDefault: true,
          ),
        ],
        printPdf:
            ({
              required printer,
              required pdfBytes,
              required paperWidthMm,
              required paperHeightMm,
              required jobType,
            }) async {
              printedOn = printer;
              printedJob = jobType;
              expect(ascii.decode(pdfBytes.take(4).toList()), '%PDF');
              expect(paperWidthMm, 210);
              expect(paperHeightMm, 297);
              return true;
            },
      );
      await service.start();
      addTearDown(service.stop);
      final client = HttpClient();
      addTearDown(client.close);
      final base = Uri.parse('http://127.0.0.1:${service.boundPort}');

      final health = await client.getUrl(base.resolve('/health'));
      final healthResponse = await health.close();
      expect(healthResponse.statusCode, HttpStatus.ok);

      final deniedRequest = await client.getUrl(base.resolve('/api/printers'));
      final deniedResponse = await deniedRequest.close();
      expect(deniedResponse.statusCode, HttpStatus.unauthorized);

      final printersRequest = await client.getUrl(
        base.resolve('/api/printers'),
      );
      printersRequest.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $token',
      );
      printersRequest.headers.set('origin', 'https://shop.replit.dev');
      final printersResponse = await printersRequest.close();
      expect(printersResponse.statusCode, HttpStatus.ok);
      expect(
        printersResponse.headers.value(
          HttpHeaders.accessControlAllowOriginHeader,
        ),
        'https://shop.replit.dev',
      );

      final printRequest = await client.postUrl(base.resolve('/api/print'));
      printRequest.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $token',
      );
      printRequest.headers.contentType = ContentType.json;
      printRequest.add(
        utf8.encode(
          jsonEncode({
            'printerName': 'Invoice printer',
            'jobType': 'invoice',
            'pdfBase64': base64Encode(ascii.encode('%PDF-1.4 test')),
          }),
        ),
      );
      final printResponse = await printRequest.close();
      expect(printResponse.statusCode, HttpStatus.accepted);
      expect(printedOn?.name, 'Invoice printer');
      expect(printedJob, 'invoice');
    },
  );

  test('private network preflight is enabled for Replit app origins', () async {
    final service = LocalPrinterHttpService(
      token: token,
      port: 0,
      listPrinters: () async => const [],
      printPdf:
          ({
            required printer,
            required pdfBytes,
            required paperWidthMm,
            required paperHeightMm,
            required jobType,
          }) async => true,
    );
    await service.start();
    addTearDown(service.stop);
    final client = HttpClient();
    addTearDown(client.close);
    final request = await client.openUrl(
      'OPTIONS',
      Uri.parse('http://127.0.0.1:${service.boundPort}/api/printers'),
    );
    request.headers.set('origin', 'https://shop.replit.dev');
    request.headers.set('Access-Control-Request-Private-Network', 'true');
    final response = await request.close();
    expect(response.statusCode, HttpStatus.noContent);
    expect(
      response.headers.value('access-control-allow-private-network'),
      'true',
    );
  });
}
