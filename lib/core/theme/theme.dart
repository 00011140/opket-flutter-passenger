import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/theme/typography.dart';

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
    ),
  ),
  textTheme: AppTypography.textTheme,
  highlightColor: Colors.transparent,
  splashColor: const Color.fromARGB(20, 0, 0, 0),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: AppColors.primary,
    selectionHandleColor: Colors.black,
  ),

  iconButtonTheme: IconButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: CircleBorder(),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconSize: 28,
      padding: EdgeInsets.all(AppSpacing.sm),
    ),
  ),
);
