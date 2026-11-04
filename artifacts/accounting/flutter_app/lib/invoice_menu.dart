import 'package:flutter/material.dart';

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
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.ink,
                minimumSize: const Size(64, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
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
    return Material(
      color: AppColors.green,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFCFE3C9), width: 1.4),
        borderRadius: BorderRadius.circular(2),
      ),
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.greenLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                style: const TextStyle(
                  color: Color(0xFFE6F2E0),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
