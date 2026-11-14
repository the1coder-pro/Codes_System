import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<bool> downloadInvoicePdf({
  required Uint8List bytes,
  required String fileName,
}) async {
  final path = await FilePicker.saveFile(
    dialogTitle: 'حفظ الفاتورة',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: const ['pdf'],
    bytes: bytes,
  );
  return path != null;
}
