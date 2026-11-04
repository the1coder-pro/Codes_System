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

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'NotoSansArabic',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.canvasBlue,
      surface: AppColors.paper,
    ),
    scaffoldBackgroundColor: AppColors.chrome,
    visualDensity: VisualDensity.compact,
  );
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
    borderSide: BorderSide(color: AppColors.line),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      border: border,
      enabledBorder: border,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(color: Color(0xFFD3D8DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        borderSide: BorderSide(color: AppColors.canvasBlue, width: 1.6),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
    ),
  );
}
