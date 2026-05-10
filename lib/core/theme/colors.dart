import 'package:flutter/material.dart';

class AppColors {
  // Static (shared across themes)
  static const primary = Color(0xFFFFE711); // Green
  static const secondary = Color(0xFF2196F3); // Blue
  static const error = Color(0xFFF44336); // Red
  static const success = Color.fromARGB(255, 27, 204, 33); // Red
  static const accent = Color(0xFFFBBF24); // Amber
  static const gray30 = Color(0xFFD1D5DB); // Amber

  // Light Theme Colors
  static const light = _AppColorScheme(
    background: Color(0xFFF9FAFB),
    backgroundDark: Color(0xFFEBEEF1),
    surface: Colors.white,
    onSurfaceBg: Color(0xFFEEEEEE),
    textPrimary: Color(0xFF1F2937),
    textSecondary: Color(0xFF4B5563),
    divider: Color(0xFFBDBDBD),
    card: Colors.white,
    appBar: primary,
    outline: Color(0xFFD1D5DB),
    surfaceSecondary: Color(0xFFE5E7EB),
  );

  // Dark Theme Colors
  static const dark = _AppColorScheme(
    background: Color(0xFF121212),
    backgroundDark: Color.fromARGB(255, 13, 13, 13),
    surface: Color(0xFF1E1E1E),
    onSurfaceBg: Color.fromARGB(255, 42, 42, 42),
    textPrimary: Colors.white,
    textSecondary: Color(0xFFB0BEC5),
    divider: Color(0xFF424242),
    card: Color(0xFF1E1E1E),
    appBar: Color(0xFF1E1E1E),
    outline: Color(0xFF1E1E1E),
    surfaceSecondary: Color(0xFF454545),
  );

  /// Call this with `context` to get the appropriate theme colors
  static _AppColorScheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }
}

class _AppColorScheme {
  final Color background;
  final Color backgroundDark;
  final Color surface;
  final Color onSurfaceBg;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color card;
  final Color outline;
  final Color appBar;
  final Color surfaceSecondary;

  const _AppColorScheme({
    required this.background,
    required this.backgroundDark,
    required this.surface,
    required this.onSurfaceBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.card,
    required this.outline,
    required this.appBar,
    required this.surfaceSecondary,
  });
}
