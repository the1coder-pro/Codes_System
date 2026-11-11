import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// Two adjacent panels separated by a draggable divider.
class ResizableSplit extends StatefulWidget {
  final Widget first;
  final Widget second;
  final double initialFirstFraction;
  final double minFirstWidth;
  final double minSecondWidth;
  final Key? dividerKey;

  const ResizableSplit({
    super.key,
    required this.first,
    required this.second,
    required this.initialFirstFraction,
    required this.minFirstWidth,
    required this.minSecondWidth,
    this.dividerKey,
  });

  @override
  State<ResizableSplit> createState() => _ResizableSplitState();
}

class _ResizableSplitState extends State<ResizableSplit> {
  static const _dividerHitWidth = 10.0;
  double? _firstFraction;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final available = math.max(0.0, width - _dividerHitWidth);
      final minFirst = math.min(widget.minFirstWidth, available);
      final minSecond = math.min(widget.minSecondWidth, available);
      final maxFirst = math.max(minFirst, available - minSecond);
      final fraction = (_firstFraction ?? widget.initialFirstFraction).clamp(
        0.0,
        1.0,
      );
      final firstWidth = (available * fraction)
          .clamp(minFirst, maxFirst)
          .toDouble();

      void setFirstWidth(double requestedWidth) {
        if (available <= 0) return;
        final nextWidth = requestedWidth.clamp(minFirst, maxFirst).toDouble();
        setState(() => _firstFraction = nextWidth / available);
      }

      void resizeBy(double delta) {
        final direction = Directionality.of(context) == TextDirection.rtl
            ? -1.0
            : 1.0;
        setFirstWidth(firstWidth + delta * direction);
      }

      final increased = math.min(maxFirst, firstWidth + 16);
      final decreased = math.max(minFirst, firstWidth - 16);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: firstWidth, child: widget.first),
          Semantics(
            label: 'تغيير عرض اللوحتين',
            value: '${firstWidth.round()} بكسل',
            increasedValue: '${increased.round()} بكسل',
            decreasedValue: '${decreased.round()} بكسل',
            onIncrease: () => setFirstWidth(firstWidth + 16),
            onDecrease: () => setFirstWidth(firstWidth - 16),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: widget.dividerKey,
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) => resizeBy(details.delta.dx),
                child: SizedBox(
                  width: _dividerHitWidth,
                  child: Center(
                    child: Container(width: 1, color: AppColors.line),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: widget.second),
        ],
      );
    },
  );
}
