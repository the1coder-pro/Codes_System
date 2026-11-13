import 'dart:js_interop';

@JS('window.open')
external JSAny? _openWindow(JSString url, JSString target, JSString features);

@JS()
extension type _PrintWindow(JSObject _) implements JSObject {
  external _PrintDocument get document;
  external void focus();
  external void print();
  external void close();
}

@JS()
extension type _PrintDocument(JSObject _) implements JSObject {
  external void open();
  external void write(JSString html);
  external void close();
}

class PrintDocumentWindow {
  final _PrintWindow _target;

  PrintDocumentWindow._(this._target);

  void writeAndPrint(String documentHtml) {
    _target.document
      ..open()
      ..write(documentHtml.toJS)
      ..close();
    _target
      ..focus()
      ..print();
  }

  void close() => _target.close();
}

PrintDocumentWindow? openPrintWindow() {
  final opened = _openWindow(
    ''.toJS,
    '_blank'.toJS,
    'width=900,height=700'.toJS,
  );
  if (opened == null) return null;
  return PrintDocumentWindow._(_PrintWindow(opened as JSObject));
}

void printLabels(String documentHtml) {
  final target = openPrintWindow();
  if (target == null) {
    throw StateError('The browser blocked the print window.');
  }
  target.writeAndPrint(documentHtml);
}
