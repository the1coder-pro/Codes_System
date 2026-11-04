import 'package:flutter/material.dart';

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
  final TextInputType? keyboard;
  const TextBox({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.align = TextAlign.start,
    this.onChanged,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      textAlign: align,
      onChanged: onChanged,
      keyboardType: keyboard,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        fillColor: enabled ? Colors.white : const Color(0xFFEDEFF1),
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
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: onChanged == null ? const Color(0xFFEDEFF1) : Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: const Text('▾', style: TextStyle(fontSize: 14)),
          style: const TextStyle(fontSize: 14, color: AppColors.ink),
          items: opts
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged == null ? null : (v) => onChanged!(v!),
        ),
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
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.line),
          borderRadius: BorderRadius.circular(3),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3),
          hoverColor: const Color(0xFFE3EEF9),
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
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: const InputDecoration(
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.canvasBlue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      ),
    );
  }
}

Future<bool> confirmDialog(
  BuildContext context,
  String title,
  String message,
) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
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
