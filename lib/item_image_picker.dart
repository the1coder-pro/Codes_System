import 'dart:typed_data';

import 'item_image_picker_stub.dart'
    if (dart.library.html) 'item_image_picker_web.dart'
    as implementation;

Future<Uint8List?> pickItemImageBytes() => implementation.pickItemImageBytes();
