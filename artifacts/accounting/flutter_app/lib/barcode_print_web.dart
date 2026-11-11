import 'dart:js_interop';

@JS('window.open')
external JSAny? _openWindow(JSString url, JSString target, JSString features);

@JS()
extension type _PrintWindow(JSObject _) implements JSObject {
  external _PrintDocument get document;
  external void focus();
  external void print();
}

@JS()
extension type _PrintDocument(JSObject _) implements JSObject {
  external void open();
  external void write(JSString html);
  external void close();
}

void printLabels(String documentHtml) {
  final opened = _openWindow(
    ''.toJS,
    '_blank'.toJS,
    'width=900,height=700'.toJS,
  );
  if (opened == null) {
    throw StateError('The browser blocked the print window.');
  }
  final target = _PrintWindow(opened as JSObject);
  target.document
    ..open()
    ..write(documentHtml.toJS)
    ..close();
  target.focus();
  target.print();
}
