class PrintDocumentWindow {
  void writeAndPrint(String documentHtml) {
    throw UnsupportedError('Printing is only available in a web browser.');
  }

  void close() {}
}

PrintDocumentWindow? openPrintWindow() => null;

void printLabels(String documentHtml) {
  throw UnsupportedError('Printing is only available in a web browser.');
}
