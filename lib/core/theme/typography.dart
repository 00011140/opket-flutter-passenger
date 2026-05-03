import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Nunito';

  static const _base = TextStyle(
    fontFamily: fontFamily,
    height: 1.3, // Better readability
    letterSpacing: 0.2,
  );

  static TextTheme textTheme = TextTheme(
    // Display
    displayLarge: _base.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    displayMedium: _base.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    displaySmall: _base.copyWith(fontSize: 28, fontWeight: FontWeight.w600),

    // Headlines
    headlineLarge: _base.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
    headlineMedium: _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
    headlineSmall: _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600),

    // Titles
    titleLarge: _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
    titleMedium: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
    titleSmall: _base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.4,
    ),

    // Body
    bodyLarge: _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: _base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),

    // Labels (buttons, chips, etc.)
    labelLarge: _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    labelMedium: _base.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: _base.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}
