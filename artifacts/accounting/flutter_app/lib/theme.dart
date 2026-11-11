import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Palette lifted from the desktop software, tuned for legibility.
class AppColors {
  static const canvasBlue = Color(0xFF1D5FA6);
  static const chrome = Color(0xFFF3F5F8);
  static const ribbon = Color(0xFFFBFCFD);
  static const line = Color(0xFFB9C2CC);
  static const ink = Color(0xFF1B2430);
  static const muted = Color(0xFF5B6673);
  static const cyan = Color(0xFFB2DDE5);
  static const cyanDeep = Color(0xFF8CC7D2);
  static const green = Color(0xFF226B12);
  static const greenLight = Color(0xFF2E8A1A);
  static const red = Color(0xFFD7261E);
  static const pink = Color(0xFFF7B9C0);
  static const mint = Color(0xFFE6F6E6);
  static const navy = Color(0xFF1347A8);
  static const paper = Color(0xFFFDFDFC);
  static const grid = Color(0xFFDCE1E6);
}

fluent.FluentThemeData buildFluentTheme() => fluent.FluentThemeData(
  fontFamily: 'IBMPlexSansArabic',
  accentColor: fluent.AccentColor.swatch({'normal': AppColors.canvasBlue}),
  scaffoldBackgroundColor: AppColors.chrome,
  cardColor: Colors.white,
  menuColor: Colors.white,
  inactiveColor: AppColors.ink,
  activeColor: Colors.white,
  selectionColor: const Color(0x553B82C4),
  visualDensity: VisualDensity.compact,
  animationCurve: Curves.easeOutCubic,
  fasterAnimationDuration: const Duration(milliseconds: 55),
  fastAnimationDuration: const Duration(milliseconds: 100),
  mediumAnimationDuration: const Duration(milliseconds: 220),
);
