import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'theme.dart';

/// Label + field pair, desktop-form style (label on the right in RTL).
class FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final double labelWidth;
  const FieldRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      style: const TextStyle(fontSize: 14),
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
  const DropBox({
    super.key,
    required this.value,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final opts = options.contains(value) ? options : [value, ...options];
    return SizedBox(
      height: 36,
      child: fluent.ComboBox<String>(
        value: value,
        isExpanded: true,
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
  final String label;
  final Color glyphColor;
  final VoidCallback? onTap;
  final double width;
  final double height;
  const ActionTile({
    super.key,
    required this.glyph,
    required this.label,
    this.glyphColor = AppColors.navy,
    this.onTap,
    this.width = 74,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
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
                Text(
                  glyph,
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.1,
                    color: glyphColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
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
class EditableGrid extends StatelessWidget {
  final List<GridColumn> columns;
  final int rowCount;
  final Widget Function(int row, int col) cell;
  final int? selectedRow;
  final ValueChanged<int>? onSelectRow;
  final Color headerColor;

  const EditableGrid({
    super.key,
    required this.columns,
    required this.rowCount,
    required this.cell,
    this.selectedRow,
    this.onSelectRow,
    this.headerColor = const Color(0xFFF1F3F5),
  });

  @override
  Widget build(BuildContext context) {
    final total = columns.fold<double>(24, (s, c) => s + c.width);
    return LayoutBuilder(
      builder: (context, box) {
        final width = total < box.maxWidth ? box.maxWidth : total;
        return Scrollbar(
          thumbVisibility: true,
          notificationPredicate: (n) => n.depth == 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  Container(
                    color: headerColor,
                    child: Row(
                      children: [
                        _cellBox(24, const SizedBox()),
                        for (var c = 0; c < columns.length; c++)
                          _cellBox(
                            c == columns.length - 1
                                ? columns[c].width + (width - total)
                                : columns[c].width,
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                                columns[c].title,
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
                      itemCount: rowCount,
                      itemBuilder: (context, r) {
                        final sel = r == selectedRow;
                        return GestureDetector(
                          onTap: onSelectRow == null
                              ? null
                              : () => onSelectRow!(r),
                          child: Container(
                            color: sel ? const Color(0xFFDDEBFA) : null,
                            child: Row(
                              children: [
                                _cellBox(
                                  24,
                                  Center(
                                    child: Text(
                                      sel ? '▸' : '${r + 1}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),
                                ),
                                for (var c = 0; c < columns.length; c++)
                                  _cellBox(
                                    c == columns.length - 1
                                        ? columns[c].width + (width - total)
                                        : columns[c].width,
                                    cell(r, c),
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

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
}

String money(double v) => v.toStringAsFixed(2);
