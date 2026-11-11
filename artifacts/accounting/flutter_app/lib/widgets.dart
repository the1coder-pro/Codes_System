import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'theme.dart';

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

/// Square desktop-style action tile with a unicode glyph.
class ActionTile extends StatelessWidget {
  final String glyph;
  final IconData? icon;
  final String label;
  final Color glyphColor;
  final VoidCallback? onTap;
  final double width;
  final double height;
  const ActionTile({
    super.key,
    this.glyph = '',
    this.icon,
    required this.label,
    this.glyphColor = AppColors.navy,
    this.onTap,
    this.width = 74,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final multiline = label.contains('\n');
    return Opacity(
      opacity: enabled ? 1 : 0.42,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(4),
        ),
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
                if (icon != null)
                  Icon(icon, size: multiline ? 20 : 24, color: glyphColor)
                else
                  Text(
                    glyph,
                    style: TextStyle(
                      fontSize: multiline ? 21 : 24,
                      height: multiline ? 1 : 1.1,
                      color: glyphColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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

void toast(
  BuildContext context,
  String msg, {
  fluent.InfoBarSeverity severity = fluent.InfoBarSeverity.info,
}) {
  unawaited(
    fluent.displayInfoBar(
      context,
      alignment: Alignment.topRight,
      builder: (context, close) =>
          fluent.InfoBar(title: Text(msg), severity: severity, onClose: close),
      duration: const Duration(seconds: 2),
    ),
  );
}

String money(double v) => v.toStringAsFixed(2);
