import 'dart:typed_data';

import 'invoice_pdf_download_stub.dart'
    if (dart.library.js_interop) 'invoice_pdf_download_web.dart'
    as platform;

Future<bool> downloadInvoicePdf({
  required Uint8List bytes,
  required String fileName,
}) => platform.downloadInvoicePdf(bytes: bytes, fileName: fileName);
