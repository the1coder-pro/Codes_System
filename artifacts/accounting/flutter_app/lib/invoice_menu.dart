import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'models.dart';
import 'theme.dart';

/// Green bilingual list of invoice types, right aligned on the blue canvas.
class InvoiceMenu extends StatelessWidget {
  final ValueChanged<int> onPick;
  final VoidCallback onClose;
  const InvoiceMenu({super.key, required this.onPick, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final menuWidth = w < 600 ? w - 24 : 280.0;
    return Container(
      color: AppColors.canvasBlue,
      child: Stack(
        children: [
          PositionedDirectional(
            top: 8,
            bottom: w < 600 ? 64 : 8,
            start: 10,
            width: menuWidth,
            child: ListView.separated(
              itemCount: invoiceTypes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (_, i) =>
                  _TypeButton(type: invoiceTypes[i], onTap: () => onPick(i)),
            ),
          ),
          PositionedDirectional(
            end: 10,
            bottom: 10,
            child: fluent.Button(
              style: fluent.ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.hovered)
                      ? const Color(0xFFEAF2FB)
                      : Colors.white,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              onPressed: onClose,
              child: const Text('إغلاق', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final InvoiceType type;
  final VoidCallback onTap;
  const _TypeButton({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return fluent.Button(
      onPressed: onTap,
      style: fluent.ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? AppColors.greenLight
              : AppColors.green,
        ),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      child: Column(
        children: [
          Text(
            type.ar,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14.5),
          ),
          Text(
            type.en,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFE6F2E0), fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
