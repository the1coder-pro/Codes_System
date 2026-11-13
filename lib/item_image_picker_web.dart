import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'item_image.dart' show maxItemImageInputBytes;

Future<Uint8List?> pickItemImageBytes() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/jpeg,image/png,image/webp,.jpg,.jpeg,.png,.webp'
    ..multiple = false
    ..style.position = 'fixed'
    ..style.left = '-10000px'
    ..style.top = '0'
    ..style.opacity = '0';
  final body = web.document.body;
  if (body == null) throw StateError('صفحة المتصفح غير جاهزة');
  body.children.add(input);

  final result = Completer<Uint8List?>();
  var completed = false;
  Timer? cancelTimer;
  void complete(Uint8List? bytes) {
    if (completed) return;
    completed = true;
    cancelTimer?.cancel();
    result.complete(bytes);
  }

  void fail(Object error) {
    if (completed) return;
    completed = true;
    cancelTimer?.cancel();
    result.completeError(error);
  }

  final changeHandler = (web.Event _) {
    final files = input.files;
    final file = files == null || files.length == 0 ? null : files.item(0);
    if (file == null) {
      complete(null);
      return;
    }
    if (file.size > maxItemImageInputBytes) {
      fail(const FormatException('اختر صورة أصغر من 12 ميجابايت'));
      return;
    }

    final reader = web.FileReader();
    final loadEndHandler = (web.Event _) {
      if (reader.error != null) {
        fail(StateError('تعذر قراءة ملف الصورة'));
        return;
      }
      final buffer = reader.result as JSArrayBuffer?;
      if (buffer == null) {
        fail(FormatException('صيغة الصورة غير مدعومة'));
        return;
      }
      complete(buffer.toDart.asUint8List());
    }.toJS;
    reader.addEventListener('loadend', loadEndHandler);
    reader.readAsArrayBuffer(file);
  }.toJS;

  final focusHandler = (web.Event _) {
    cancelTimer = Timer(const Duration(seconds: 1), () {
      final files = input.files;
      if (!completed && (files == null || files.length == 0)) complete(null);
    });
  }.toJS;
  final cancelHandler = (web.Event _) {
    complete(null);
  }.toJS;
  input.addEventListener('change', changeHandler);
  input.addEventListener('cancel', cancelHandler);
  web.window.addEventListener('focus', focusHandler);

  try {
    // Keep the click in the same user gesture as the upload button.
    input.click();
    return await result.future;
  } finally {
    cancelTimer?.cancel();
    input.removeEventListener('change', changeHandler);
    input.removeEventListener('cancel', cancelHandler);
    web.window.removeEventListener('focus', focusHandler);
    input.remove();
  }
}
