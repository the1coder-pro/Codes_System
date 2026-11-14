import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<bool> downloadInvoicePdf({
  required Uint8List bytes,
  required String fileName,
}) async {
  final body = web.document.body;
  if (body == null) throw StateError('صفحة المتصفح غير جاهزة');

  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);
  final link = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  body.children.add(link);
  try {
    link.click();
    return true;
  } finally {
    link.remove();
    Timer(const Duration(seconds: 1), () => web.URL.revokeObjectURL(url));
  }
}
