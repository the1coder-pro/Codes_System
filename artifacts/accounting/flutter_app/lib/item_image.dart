import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;

import 'theme.dart';

const maxItemImageInputBytes = 12 * 1024 * 1024;
const _maxStoredImageBytes = 400 * 1024;

String optimizeItemImage(Uint8List sourceBytes) {
  if (sourceBytes.isEmpty) {
    throw const FormatException('ملف الصورة فارغ');
  }
  if (sourceBytes.length > maxItemImageInputBytes) {
    throw const FormatException('اختر صورة أصغر من 12 ميجابايت');
  }

  final decoded = image.decodeImage(sourceBytes);
  if (decoded == null) {
    throw const FormatException('صيغة الصورة غير مدعومة');
  }

  image.Image resize(int edge) => image.copyResize(
    decoded,
    width: edge,
    height: edge,
    maintainAspect: true,
    backgroundColor: image.ColorRgb8(255, 255, 255),
    interpolation: image.Interpolation.linear,
  );

  var compressed = image.encodeJpg(resize(512), quality: 80);
  if (compressed.length > _maxStoredImageBytes) {
    compressed = image.encodeJpg(resize(384), quality: 65);
  }
  if (compressed.length > _maxStoredImageBytes) {
    throw const FormatException('تعذر ضغط الصورة إلى حجم مناسب');
  }

  return base64Encode(compressed);
}

class ItemImage extends StatelessWidget {
  final String? base64Data;
  final BoxFit fit;
  final double iconSize;
  final String emptyLabel;

  const ItemImage({
    super.key,
    required this.base64Data,
    this.fit = BoxFit.cover,
    this.iconSize = 30,
    this.emptyLabel = 'لا توجد صورة',
  });

  Widget _placeholder() => ColoredBox(
    color: const Color(0xFFF3F7F8),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: iconSize,
            color: AppColors.muted,
          ),
          if (emptyLabel.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              emptyLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ],
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final encoded = base64Data;
    if (encoded == null || encoded.isEmpty) return _placeholder();

    try {
      return Image.memory(
        base64Decode(encoded),
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    } on FormatException {
      return _placeholder();
    }
  }
}
