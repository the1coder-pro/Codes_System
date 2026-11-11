import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Uint8List?> pickItemImageBytes() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/jpeg,image/png,image/webp,.jpg,.jpeg,.png,.webp'
    ..multiple = false
    ..style.position = 'fixed'
    ..style.left = '-10000px'
    ..style.top = '0'
    ..style.opacity = '0';
  final body = html.document.body;
  if (body == null) throw StateError('صفحة المتصفح غير جاهزة');
  body.children.add(input);

  final result = Completer<Uint8List?>();
  var completed = false;
  void complete(Uint8List? bytes) {
    if (completed) return;
    completed = true;
    result.complete(bytes);
  }

  void fail(Object error) {
    if (completed) return;
    completed = true;
    result.completeError(error);
  }

  final changeSubscription = input.onChange.listen((_) {
    final files = input.files;
    final file = files == null || files.length == 0 ? null : files.item(0);
    if (file == null) {
      complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.onLoadEnd.listen((_) {
      if (reader.error != null) {
        fail(StateError('تعذر قراءة ملف الصورة'));
        return;
      }
      final data = reader.result;
      if (data is ByteBuffer) {
        complete(data.asUint8List());
      } else if (data is Uint8List) {
        complete(data);
      } else {
        fail(FormatException('صيغة الصورة غير مدعومة'));
      }
    });
    reader.readAsArrayBuffer(file);
  });

  final focusSubscription = html.window.onFocus.listen((_) {
    Future<void>.delayed(const Duration(seconds: 1), () {
      final files = input.files;
      if (!completed && (files == null || files.length == 0)) complete(null);
    });
  });

  try {
    // Keep the click in the same synchronous user gesture as the upload button.
    input.click();
    return await result.future;
  } finally {
    await changeSubscription.cancel();
    await focusSubscription.cancel();
    input.remove();
  }
}
