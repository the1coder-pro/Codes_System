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
  final bool collapsibleFirst;
  final bool firstOnLeft;
  final String collapsedLabel;
  final Key? collapseToggleKey;

  const ResizableSplit({
    super.key,
    required this.first,
    required this.second,
    required this.initialFirstFraction,
    required this.minFirstWidth,
    required this.minSecondWidth,
    this.dividerKey,
    this.collapsibleFirst = false,
    this.firstOnLeft = false,
    this.collapsedLabel = 'لوحة',
    this.collapseToggleKey,
  });

  @override
  State<ResizableSplit> createState() => _ResizableSplitState();
}

class _ResizableSplitState extends State<ResizableSplit> {
  static const _dividerHitWidth = 10.0;
  static const _collapsibleDividerWidth = 36.0;
  static const _collapsedRailWidth = 32.0;
  double? _firstFraction;
  bool _firstCollapsed = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final rowDirection = widget.firstOnLeft
          ? TextDirection.ltr
          : Directionality.of(context);
      final dividerWidth = widget.collapsibleFirst
          ? _collapsibleDividerWidth
          : _dividerHitWidth;
      final available = math.max(0.0, width - dividerWidth);
      final minFirst = math.min(widget.minFirstWidth, available);
      final minSecond = math.min(widget.minSecondWidth, available);
      final maxFirst = math.max(minFirst, available - minSecond);
      final fraction = (_firstFraction ?? widget.initialFirstFraction).clamp(
        0.0,
        1.0,
      );
      final firstWidth = _firstCollapsed
          ? math.min(_collapsedRailWidth, available)
          : (available * fraction).clamp(minFirst, maxFirst).toDouble();

      void setFirstWidth(double requestedWidth) {
        if (available <= 0) return;
        final nextWidth = requestedWidth.clamp(minFirst, maxFirst).toDouble();
        setState(() => _firstFraction = nextWidth / available);
      }

      void resizeBy(double delta) {
        final direction = rowDirection == TextDirection.rtl ? -1.0 : 1.0;
        setFirstWidth(firstWidth + delta * direction);
      }

      final increased = math.min(maxFirst, firstWidth + 16);
      final decreased = math.max(minFirst, firstWidth - 16);
      final firstPanel = _firstCollapsed
          ? Container(
              color: AppColors.cyan,
              alignment: Alignment.center,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  widget.collapsedLabel,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : widget.first;
      return Row(
        textDirection: rowDirection,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: firstWidth, child: firstPanel),
          Semantics(
            label: widget.collapsibleFirst
                ? 'تغيير أو إخفاء اللوحة ${widget.collapsedLabel}'
                : 'تغيير عرض اللوحتين',
            value: '${firstWidth.round()} بكسل',
            increasedValue: '${increased.round()} بكسل',
            decreasedValue: '${decreased.round()} بكسل',
            onIncrease: _firstCollapsed
                ? null
                : () => setFirstWidth(firstWidth + 16),
            onDecrease: _firstCollapsed
                ? null
                : () => setFirstWidth(firstWidth - 16),
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: widget.dividerKey,
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: _firstCollapsed
                    ? null
                    : (details) => resizeBy(details.delta.dx),
                child: SizedBox(
                  width: dividerWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(width: 1, color: AppColors.line),
                      if (widget.collapsibleFirst)
                        Material(
                          color: AppColors.paper,
                          child: IconButton(
                            key: widget.collapseToggleKey,
                            tooltip: _firstCollapsed
                                ? 'إظهار ${widget.collapsedLabel}'
                                : 'إخفاء ${widget.collapsedLabel}',
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            constraints: const BoxConstraints.tightFor(
                              width: 30,
                              height: 30,
                            ),
                            icon: Icon(
                              _firstCollapsed
                                  ? Icons.chevron_right
                                  : Icons.chevron_left,
                              size: 18,
                              color: AppColors.ink,
                            ),
                            onPressed: () => setState(
                              () => _firstCollapsed = !_firstCollapsed,
                            ),
                          ),
                        ),
                    ],
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

/// A vertically resizable pair of panels with a fold/expand control.
class ResizableVerticalSplit extends StatefulWidget {
  final Widget first;
  final Widget second;
  final double initialSecondExtent;
  final double? initialFirstExtent;
  final double minFirstExtent;
  final double minSecondExtent;
  final Key? dividerKey;
  final Key? collapseToggleKey;
  final Key? secondExtentKey;
  final bool overlaySecond;
  final bool resizeFirst;
  final bool collapsibleSecond;
  final String dividerLabel;

  const ResizableVerticalSplit({
    super.key,
    required this.first,
    required this.second,
    required this.initialSecondExtent,
    required this.minFirstExtent,
    required this.minSecondExtent,
    this.initialFirstExtent,
    this.dividerKey,
    this.collapseToggleKey,
    this.secondExtentKey,
    this.overlaySecond = false,
    this.resizeFirst = false,
    this.collapsibleSecond = true,
    this.dividerLabel = 'تغيير ارتفاع قسم البحث والتصفية',
  });

  @override
  State<ResizableVerticalSplit> createState() => _ResizableVerticalSplitState();
}

class _ResizableVerticalSplitState extends State<ResizableVerticalSplit> {
  static const _dividerHeight = 48.0;
  double? _secondExtent;
  double? _firstExtent;
  bool _secondCollapsed = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final available = math.max(0.0, constraints.maxHeight - _dividerHeight);
      final minSecond = math.min(widget.minSecondExtent, available);
      final minFirst = math.min(
        widget.minFirstExtent,
        math.max(0.0, available - minSecond),
      );
      final maxSecond = math.max(minSecond, available - minFirst);
      final initialFirst =
          widget.initialFirstExtent ?? (available - widget.initialSecondExtent);
      final firstExtent = widget.resizeFirst
          ? (_firstExtent ?? initialFirst)
                .clamp(minFirst, math.max(minFirst, available - minSecond))
                .toDouble()
          : 0.0;
      final secondExtent = widget.resizeFirst
          ? math.max(0.0, available - firstExtent)
          : (_secondExtent ?? widget.initialSecondExtent)
                .clamp(minSecond, maxSecond)
                .toDouble();
      final secondHeight = _secondCollapsed ? 0.0 : secondExtent;
      final firstHeight = widget.resizeFirst
          ? (_secondCollapsed ? available : firstExtent)
          : math.max(0.0, available - secondHeight);

      void setSplitExtent(double requested) {
        setState(() {
          _secondCollapsed = false;
          if (widget.resizeFirst) {
            _firstExtent = requested
                .clamp(minFirst, math.max(minFirst, available - minSecond))
                .toDouble();
          } else {
            _secondExtent = requested.clamp(minSecond, maxSecond).toDouble();
          }
        });
      }

      void resizeBy(double delta) {
        setSplitExtent(
          widget.resizeFirst ? firstExtent + delta : secondExtent - delta,
        );
      }

      final expanding = _secondCollapsed || secondHeight == 0;
      final handle = Semantics(
        label: widget.dividerLabel,
        value: _secondCollapsed
            ? 'مطوي'
            : '${(widget.resizeFirst ? firstHeight : secondHeight).round()} بكسل',
        increasedValue:
            '${(widget.resizeFirst ? math.min(available - minSecond, firstExtent + 16) : math.min(maxSecond, secondExtent + 16)).round()} بكسل',
        decreasedValue:
            '${(widget.resizeFirst ? math.max(minFirst, firstExtent - 16) : math.max(minSecond, secondExtent - 16)).round()} بكسل',
        onIncrease: _secondCollapsed
            ? null
            : () => setSplitExtent(
                widget.resizeFirst ? firstExtent + 16 : secondExtent + 16,
              ),
        onDecrease: _secondCollapsed
            ? null
            : () => setSplitExtent(
                widget.resizeFirst ? firstExtent - 16 : secondExtent - 16,
              ),
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeRow,
          child: GestureDetector(
            key: widget.dividerKey,
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) => resizeBy(details.delta.dy),
            child: SizedBox(
              height: _dividerHeight,
              width: double.infinity,
              child: ColoredBox(
                color: AppColors.paper,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 1, color: AppColors.line),
                    if (widget.collapsibleSecond)
                      Material(
                        color: AppColors.paper,
                        child: IconButton(
                          key: widget.collapseToggleKey,
                          tooltip: expanding
                              ? 'إظهار البحث والتصفية'
                              : 'طي البحث والتصفية',
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          icon: Icon(
                            expanding
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.ink,
                          ),
                          onPressed: () => setState(() {
                            if (expanding) {
                              _secondCollapsed = false;
                              if (secondExtent == 0) {
                                if (widget.resizeFirst) {
                                  _firstExtent = math.max(
                                    minFirst,
                                    available -
                                        math.min(
                                          widget.initialSecondExtent,
                                          maxSecond,
                                        ),
                                  );
                                } else {
                                  _secondExtent = math.min(
                                    widget.initialSecondExtent,
                                    maxSecond,
                                  );
                                }
                              }
                            } else {
                              _secondExtent = secondHeight;
                              _secondCollapsed = true;
                            }
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      final secondPanel = SizedBox(
        key: widget.secondExtentKey,
        height: secondHeight,
        width: double.infinity,
        child: Visibility(
          visible: !_secondCollapsed,
          maintainState: true,
          child: widget.second,
        ),
      );

      if (widget.overlaySecond) {
        return Stack(
          fit: StackFit.expand,
          children: [
            widget.first,
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: _dividerHeight + secondHeight,
                width: double.infinity,
                child: Column(children: [handle, secondPanel]),
              ),
            ),
          ],
        );
      }

      return Column(
        children: [
          SizedBox(
            height: firstHeight,
            width: double.infinity,
            child: widget.first,
          ),
          handle,
          secondPanel,
        ],
      );
    },
  );
}
