import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    /// Main colors
    // Transparent canvas color
    canvasColor: AppColors.backgroundColor,
    // Primary color for the app
    primaryColor: AppColors.primary,
    // Light variant of the primary color
    primaryColorLight: AppColors.primary,
    // Dark variant of the primary color
    primaryColorDark: AppColors.primary,

    /// Color scheme for the app
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
      // Light theme brightness
      // Primary color
      primary: AppColors.primary,
      // Color for content on primary color
      onPrimary: AppColors.primary,
      // Secondary color
      secondary: AppColors.secondary,
      // Color for content on secondary color
      onSecondary: AppColors.secondary,
      // Surface color
      //surface: AppColors.backgroundColor,
      // Color for content on surface
      onSurface: AppColors.white,
      // Error color
      error: AppColors.red,
      // Color for content on error color
      onError: AppColors.red,
    ),
    inputDecorationTheme: InputDecorationTheme(
      // Label text style
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
    ),
  );
}
