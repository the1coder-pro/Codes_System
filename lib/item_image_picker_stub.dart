import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<Uint8List?> pickItemImageBytes() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
    allowMultiple: false,
    withData: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final bytes = result.files.single.bytes;
  if (bytes == null || bytes.isEmpty) {
    throw const FormatException('تعذر قراءة الصورة المختارة');
  }
  return bytes;
}
