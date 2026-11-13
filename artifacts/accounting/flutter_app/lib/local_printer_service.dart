import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class PrinterDevice {
  final String name;
  final String displayName;
  final String description;
  final bool isDefault;

  const PrinterDevice({
    required this.name,
    required this.displayName,
    required this.description,
    required this.isDefault,
  });

  Map<String, Object?> toJson() => {
    'name': name,
    'displayName': displayName,
    'description': description,
    'isDefault': isDefault,
  };
}

typedef PrinterListCallback = Future<List<PrinterDevice>> Function();

typedef PrinterPdfCallback =
    Future<bool> Function({
      required PrinterDevice printer,
      required Uint8List pdfBytes,
      required double paperWidthMm,
      required double paperHeightMm,
      required String jobType,
    });

class LocalPrinterHttpService {
  static const defaultPort = 17863;
  static const _maxBodyBytes = 24 * 1024 * 1024;

  final String token;
  final int port;
  final PrinterListCallback listPrinters;
  final PrinterPdfCallback printPdf;
  final List<String> extraOrigins;

  HttpServer? _server;
  StreamSubscription<HttpRequest>? _requests;

  LocalPrinterHttpService({
    required this.token,
    required this.listPrinters,
    required this.printPdf,
    this.port = defaultPort,
    this.extraOrigins = const [],
  }) {
    if (token.length < 40) {
      throw ArgumentError.value(token, 'token', 'Must be at least 40 chars');
    }
  }

  bool get isRunning => _server != null;
  int get boundPort => _server?.port ?? port;

  Future<void> start() async {
    if (_server != null) return;
    _server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port,
      shared: false,
    );
    _requests = _server!.listen(_handleRequest, onError: (Object error) {});
  }

  Future<void> stop() async {
    await _requests?.cancel();
    _requests = null;
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final origin = request.headers.value('origin');
    if (origin != null) {
      if (!_isAllowedOrigin(origin)) {
        await _sendJson(request.response, HttpStatus.forbidden, {
          'error': 'origin_not_allowed',
        });
        return;
      }
      final headers = request.response.headers;
      headers
        ..set(HttpHeaders.accessControlAllowOriginHeader, origin)
        ..set(HttpHeaders.varyHeader, 'Origin')
        ..set(
          HttpHeaders.accessControlAllowHeadersHeader,
          'Authorization, Content-Type',
        )
        ..set(HttpHeaders.accessControlAllowMethodsHeader, 'GET, POST, OPTIONS')
        ..set('Access-Control-Allow-Private-Network', 'true');
    }

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    final path = request.uri.path;
    if (request.method == 'GET' && path == '/health') {
      await _sendJson(request.response, HttpStatus.ok, {'ok': true});
      return;
    }
    if (path.startsWith('/api/') && !_hasValidToken(request)) {
      await _sendJson(request.response, HttpStatus.unauthorized, {
        'error': 'unauthorized',
      });
      return;
    }
    if (request.method == 'GET' && path == '/api/printers') {
      try {
        final printers = await listPrinters();
        await _sendJson(
          request.response,
          HttpStatus.ok,
          printers.map((printer) => printer.toJson()).toList(),
        );
      } catch (_) {
        await _sendJson(request.response, HttpStatus.serviceUnavailable, {
          'error': 'printer_discovery_failed',
        });
      }
      return;
    }
    if (request.method == 'POST' && path == '/api/print') {
      await _handlePrint(request);
      return;
    }
    await _sendJson(request.response, HttpStatus.notFound, {
      'error': 'not_found',
    });
  }

  Future<void> _handlePrint(HttpRequest request) async {
    final bodyBytes = await _readBody(request);
    if (bodyBytes == null) return;
    Map<String, dynamic> job;
    try {
      final decoded = jsonDecode(utf8.decode(bodyBytes));
      if (decoded is! Map) throw const FormatException();
      job = Map<String, dynamic>.from(decoded);
    } catch (_) {
      await _sendJson(request.response, HttpStatus.badRequest, {
        'error': 'invalid_json',
      });
      return;
    }

    final printerName = job['printerName'] is String
        ? (job['printerName'] as String).trim()
        : '';
    final jobType = job['jobType'];
    final encodedPdf = job['pdfBase64'];
    if (printerName.isEmpty ||
        encodedPdf is! String ||
        !{'invoice', 'barcode'}.contains(jobType)) {
      await _sendJson(request.response, HttpStatus.badRequest, {
        'error': 'invalid_print_job',
      });
      return;
    }

    Uint8List pdfBytes;
    try {
      pdfBytes = base64Decode(encodedPdf);
      if (pdfBytes.length < 4 ||
          ascii.decode(pdfBytes.take(4).toList()) != '%PDF' ||
          pdfBytes.length > _maxBodyBytes) {
        throw const FormatException();
      }
    } catch (_) {
      await _sendJson(request.response, HttpStatus.badRequest, {
        'error': 'invalid_pdf',
      });
      return;
    }

    final width = _validPaperSize(job['paperWidthMm']) ?? 210.0;
    final height = _validPaperSize(job['paperHeightMm']) ?? 297.0;
    try {
      final printers = await listPrinters();
      final matches = printers
          .where((candidate) => candidate.name == printerName)
          .toList();
      final printer = matches.isEmpty ? null : matches.first;
      if (printer == null) {
        await _sendJson(request.response, HttpStatus.conflict, {
          'error': 'printer_not_found',
        });
        return;
      }
      final printed = await printPdf(
        printer: printer,
        pdfBytes: pdfBytes,
        paperWidthMm: width,
        paperHeightMm: height,
        jobType: jobType as String,
      );
      if (!printed) {
        await _sendJson(request.response, HttpStatus.internalServerError, {
          'error': 'print_failed',
        });
        return;
      }
      await _sendJson(request.response, HttpStatus.accepted, {'ok': true});
    } catch (_) {
      await _sendJson(request.response, HttpStatus.internalServerError, {
        'error': 'print_failed',
      });
    }
  }

  Future<List<int>?> _readBody(HttpRequest request) async {
    final builder = BytesBuilder(copy: false);
    var size = 0;
    var tooLarge = false;
    await for (final chunk in request) {
      if (tooLarge) continue;
      size += chunk.length;
      if (size > _maxBodyBytes) {
        tooLarge = true;
        builder.clear();
        continue;
      }
      builder.add(chunk);
    }
    if (tooLarge) {
      await _sendJson(request.response, 413, {'error': 'request_too_large'});
      return null;
    }
    return builder.takeBytes();
  }

  bool _hasValidToken(HttpRequest request) =>
      request.headers.value(HttpHeaders.authorizationHeader) == 'Bearer $token';

  bool _isAllowedOrigin(String origin) {
    if (extraOrigins.contains(origin)) return true;
    final uri = Uri.tryParse(origin);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    if ((uri.scheme == 'http' || uri.scheme == 'https') &&
        {'localhost', '127.0.0.1', '::1'}.contains(host)) {
      return true;
    }
    return uri.scheme == 'https' &&
        (host.endsWith('.replit.dev') || host.endsWith('.replit.app'));
  }

  double? _validPaperSize(Object? value) {
    if (value is! num) return null;
    final size = value.toDouble();
    return size > 10 && size <= 1000 ? size : null;
  }

  Future<void> _sendJson(HttpResponse response, int status, Object body) async {
    response
      ..statusCode = status
      ..headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=utf-8',
      )
      ..headers.set(HttpHeaders.cacheControlHeader, 'no-store');
    response.write(jsonEncode(body));
    await response.close();
  }
}
