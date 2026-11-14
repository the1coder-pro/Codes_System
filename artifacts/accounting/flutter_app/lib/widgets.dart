import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'theme.dart';

class AppIcons {
  static const add = 'assets/icons/icons8-add-96.png';
  static const calculator = 'assets/icons/icons8-calculator-96.png';
  static const cash = 'assets/icons/icons8-cash-96.png';
  static const delete = 'assets/icons/icons8-remove-properties-96.png';
  static const edit = 'assets/icons/icons8-edit-96.png';
  static const exit = 'assets/icons/icons8-exit-96.png';
  static const lock = 'assets/icons/icons8-lock-96.png';
  static const network = 'assets/icons/icons8-transaction-96.png';
  static const printer = 'assets/icons/icons8-printer-96.png';
  static const saveAndPrintPrinter = 'assets/icons/icons8-printer-save-96.png';
  static const profit = 'assets/icons/icons8-profit-report-96.png';
  static const receipt = 'assets/icons/icons8-receipt-96.png';
  static const refresh = 'assets/icons/icons8-refresh-96.png';
  static const save = 'assets/icons/icons8-save-96.png';
  static const search = 'assets/icons/icons8-search-96.png';
  static const shop = 'assets/icons/icons8-shopping-cart-96.png';
  static const test = 'assets/icons/icons8-test-96.png';
  static const undo = 'assets/icons/icons8-undo-96.png';
  static const users = 'assets/icons/icons8-users-96.png';
  static const website = 'assets/icons/icons8-website-96.png';
}

class AppImageIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const AppImageIcon(this.assetPath, {super.key, this.size = 24});

  @override
  Widget build(BuildContext context) => Image.asset(
    assetPath,
    width: size,
    height: size,
    fit: BoxFit.contain,
    excludeFromSemantics: true,
  );
}

/// Label + field pair, desktop-form style (label on the right in RTL).
class FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final double labelWidth;
  final bool compact;
  const FieldRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 120,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 2 : 4),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: TextStyle(
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w600,
                height: compact ? 1 : 1.15,
              ),
            ),
          ),
          SizedBox(width: compact ? 6 : 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final int maxLines;
  final TextAlign align;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboard;
  final String? placeholder;
  final TextDirection? textDirection;
  final bool autofocus;
  final bool readOnly;
  final bool compact;
  const TextBox({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.align = TextAlign.start,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboard,
    this.placeholder,
    this.textDirection,
    this.autofocus = false,
    this.readOnly = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return fluent.TextBox(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      textAlign: align,
      textDirection: textDirection,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      keyboardType: keyboard,
      placeholder: placeholder,
      autofocus: autofocus,
      readOnly: readOnly,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 3 : 7),
      style: TextStyle(fontSize: compact ? 12 : 14),
      decoration: WidgetStateProperty.resolveWith(
        (states) => BoxDecoration(
          color: states.contains(WidgetState.disabled)
              ? const Color(0xFFF1F3F5)
              : Colors.white,
          border: Border.all(
            color: states.contains(WidgetState.focused)
                ? AppColors.canvasBlue
                : AppColors.line,
            width: states.contains(WidgetState.focused) ? 1.4 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class DropBox extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;
  final bool compact;
  const DropBox({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final opts = options.contains(value) ? options : [value, ...options];
    return SizedBox(
      height: compact ? 34 : 36,
      child: fluent.ComboBox<String>(
        value: value,
        isExpanded: true,
        style: TextStyle(fontSize: compact ? 12 : 14),
        items: opts
            .map(
              (option) =>
                  fluent.ComboBoxItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged == null
            ? null
            : (value) {
                if (value != null) onChanged!(value);
              },
      ),
    );
  }
}

/// Square desktop-style action tile with an image or Fluent icon.
class ActionTile extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final String label;
  final Color glyphColor;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final bool hideLabel;
  const ActionTile({
    super.key,
    this.assetPath,
    this.icon,
    required this.label,
    this.glyphColor = AppColors.navy,
    this.onTap,
    this.width = 74,
    this.height = 70,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final multiline = label.contains('\n');
    final iconSize = height <= 60
        ? 21.0
        : height <= 68
        ? 24.0
        : 28.0;
    return Opacity(
      opacity: enabled ? 1 : 0.42,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Semantics(
          button: true,
          label: label,
          child: fluent.Button(
            onPressed: onTap,
            style: fluent.ButtonStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.hovered)
                    ? const Color(0xFFEAF2FB)
                    : Colors.white,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (assetPath != null)
                    AppImageIcon(assetPath!, size: iconSize)
                  else if (icon != null)
                    Icon(icon, size: multiline ? 20 : 24, color: glyphColor)
                  else
                    const SizedBox.shrink(),
                  if (!hideLabel) ...[
                    SizedBox(height: multiline ? 2 : 4),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: multiline ? 11 : 13,
                        fontWeight: FontWeight.w600,
                        height: multiline ? 1 : 1.1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridColumn {
  final String title;
  final double width;
  const GridColumn(this.title, this.width);
}

/// Spreadsheet-like grid with fixed column widths; scrolls horizontally.
class EditableGrid extends StatefulWidget {
  final List<GridColumn> columns;
  final int rowCount;
  final Widget Function(int row, int col) cell;
  final int? selectedRow;
  final ValueChanged<int>? onSelectRow;
  final Set<int> selectedRows;
  final ValueChanged<int>? onToggleRowSelection;
  final Color headerColor;

  const EditableGrid({
    super.key,
    required this.columns,
    required this.rowCount,
    required this.cell,
    this.selectedRow,
    this.onSelectRow,
    this.selectedRows = const <int>{},
    this.onToggleRowSelection,
    this.headerColor = const Color(0xFFF1F3F5),
  });

  @override
  State<EditableGrid> createState() => _EditableGridState();
}

class _EditableGridState extends State<EditableGrid> {
  final _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.columns.fold<double>(24, (s, c) => s + c.width);
    return LayoutBuilder(
      builder: (context, box) {
        final width = total < box.maxWidth ? box.maxWidth : total;
        return Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          notificationPredicate: (n) => n.depth == 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontalController,
            primary: false,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Container(
                    color: widget.headerColor,
                    child: Row(
                      children: [
                        _cellBox(24, const SizedBox()),
                        for (var c = 0; c < widget.columns.length; c++)
                          _cellBox(
                            c == widget.columns.length - 1
                                ? widget.columns[c].width + (width - total)
                                : widget.columns[c].width,
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                widget.columns[c].title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            height: 46,
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      primary: false,
                      itemCount: widget.rowCount,
                      itemBuilder: (context, r) {
                        final sel = r == widget.selectedRow;
                        final marked = widget.selectedRows.contains(r);
                        return GestureDetector(
                          onTap: widget.onSelectRow == null
                              ? null
                              : () => widget.onSelectRow!(r),
                          child: Container(
                            color: marked
                                ? const Color(0xFFDDEBFA)
                                : sel
                                ? const Color(0xFFEAF3F9)
                                : null,
                            child: Row(
                              children: [
                                _cellBox(
                                  24,
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: widget.onToggleRowSelection == null
                                        ? null
                                        : () => widget.onToggleRowSelection!(r),
                                    child: Center(
                                      child: Text(
                                        marked
                                            ? '●'
                                            : sel
                                            ? '▸'
                                            : '${r + 1}',
                                        style: TextStyle(
                                          fontSize: marked ? 9 : 11,
                                          color: marked
                                              ? AppColors.canvasBlue
                                              : AppColors.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                for (var c = 0; c < widget.columns.length; c++)
                                  _cellBox(
                                    c == widget.columns.length - 1
                                        ? widget.columns[c].width +
                                              (width - total)
                                        : widget.columns[c].width,
                                    widget.cell(r, c),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cellBox(double w, Widget child, {double height = 36}) => Container(
    width: w,
    height: height,
    decoration: const BoxDecoration(
      border: Border(
        left: BorderSide(color: AppColors.grid),
        bottom: BorderSide(color: AppColors.grid),
      ),
    ),
    alignment: AlignmentDirectional.centerStart,
    child: child,
  );
}

/// Borderless text field for grid cells.
class CellField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  const CellField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return fluent.TextBox(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      style: const TextStyle(fontSize: 13),
      decoration: WidgetStateProperty.resolveWith(
        (states) => BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: states.contains(WidgetState.focused)
                  ? AppColors.canvasBlue
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> confirmDialog(
  BuildContext context,
  String title,
  String message,
) async {
  final r = await fluent.showDialog<bool>(
    context: context,
    builder: (c) => fluent.ContentDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        fluent.Button(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('إلغاء'),
        ),
        fluent.FilledButton(
          style: fluent.ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(AppColors.red),
          ),
          onPressed: () => Navigator.pop(c, true),
          child: const Text('نعم، تأكيد'),
        ),
      ],
    ),
  );
  return r ?? false;
}

typedef _ToastKey = (String, fluent.InfoBarSeverity);

final Map<_ToastKey, _ToastEntry> _activeToasts = {};
int _nextToastId = 0;

class _ToastEntry {
  _ToastEntry() : id = _nextToastId++;

  final int id;
  final ValueNotifier<int> jiggle = ValueNotifier(0);
  Timer? timer;
}

void toast(
  BuildContext context,
  String msg, {
  fluent.InfoBarSeverity severity = fluent.InfoBarSeverity.info,
}) {
  final toastKey = (msg, severity);
  final activeToast = _activeToasts[toastKey];
  if (activeToast != null) {
    activeToast.jiggle.value++;
    return;
  }

  final entry = _ToastEntry();
  _activeToasts[toastKey] = entry;
  const duration = Duration(seconds: 2);
  final animationDuration = fluent.FluentTheme.of(
    context,
  ).mediumAnimationDuration;
  void releaseEntry() {
    if (identical(_activeToasts[toastKey], entry)) {
      _activeToasts.remove(toastKey);
    }
    entry.timer?.cancel();
  }

  entry.timer = Timer(
    duration + Duration(milliseconds: animationDuration.inMilliseconds * 2),
    releaseEntry,
  );
  unawaited(
    fluent.displayInfoBar(
      context,
      alignment: Alignment.topRight,
      builder: (context, close) => _JigglingInfoBar(
        key: ValueKey('info-bar-${entry.id}'),
        message: msg,
        severity: severity,
        jiggle: entry.jiggle,
        onClose: () {
          close();
          entry.timer?.cancel();
          entry.timer = Timer(animationDuration, releaseEntry);
        },
      ),
      duration: duration,
    ),
  );
}

class _JigglingInfoBar extends StatefulWidget {
  const _JigglingInfoBar({
    super.key,
    required this.message,
    required this.severity,
    required this.jiggle,
    required this.onClose,
  });

  final String message;
  final fluent.InfoBarSeverity severity;
  final ValueNotifier<int> jiggle;
  final VoidCallback onClose;

  @override
  State<_JigglingInfoBar> createState() => _JigglingInfoBarState();
}

class _JigglingInfoBarState extends State<_JigglingInfoBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1,
    );
    _offset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 7), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 7, end: -7), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -7, end: 4), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    widget.jiggle.addListener(_replay);
  }

  void _replay() => _controller.forward(from: 0);

  @override
  void dispose() {
    widget.jiggle.removeListener(_replay);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) =>
          Transform.translate(offset: Offset(_offset.value, 0), child: child),
      child: fluent.InfoBar(
        title: Text(widget.message),
        severity: widget.severity,
        onClose: widget.onClose,
      ),
    );
  }
}

String money(double v) => v.toStringAsFixed(2);
