import 'package:flutter/material.dart';

import '../assets/fonts.dart';
import '../constants/app_colors.dart';
/// A utility class to centralize the application's visual identity.
///
/// This class encapsulates [ThemeData] configurations for both Light and Dark modes,
/// ensuring a unified UI/UX across the entire widget tree by leveraging
/// Material 3 (M3) specifications.
class AppTheme {
  /// Global accessor for the Light Theme configuration.
  static final lightTheme = _theme(isDark: false);

  /// Global accessor for the Dark Theme configuration.
  static final darkTheme = _theme(isDark: true);

  /// A private builder method to generate [ThemeData].
  ///
  /// Uses [isDark] to toggle [Brightness] and adjust specific color mappings.
  static ThemeData _theme({required bool isDark}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      // Opts into the latest Material Design 3 features (tokens, elevations, etc.).
      useMaterial3: true,
      brightness: brightness,

      /// --- Surface & Layout Configuration ---

      // The primary background color for Scaffolds.
      // Note: In M3, 'surface' is often used instead of 'backgroundColor'.
      scaffoldBackgroundColor: AppColors.backgroundColor,

      // Background for low-level UI elements like Drawer and Menus.
      canvasColor: AppColors.backgroundColor,

      // The default background for Card widgets.
      cardColor: AppColors.white,

      // Affects the color of VerticalDivider, Divider, and DataTables.
      dividerColor: AppColors.silver,

      /// --- Global Typography ---

      // Sets the default font across the app. Ensure the family name
      // matches your pubspec.yaml exactly.
      fontFamily: FontFamily.primary.name,

      /// --- Color Palette (Material 3) ---

      // Generates a complete ColorScheme from a single seed color.
      // M3 uses these slots to calculate harmonious tones for containers,
      // surfaces, and outlines.
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: Colors.blue,

        // Primary brand color, used for high-emphasis UI elements.
        primary: AppColors.primary,

        // Ensuring high contrast for content rendered on the primary color.
        onPrimary: Colors.white,

        // Secondary color for less prominent UI components like filter chips.
        secondary: AppColors.secondary,

        // High contrast color for content on the secondary color.
        onSecondary: Colors.white,

        // The background color for cards, sheets, and dialogs.
        surface: AppColors.backgroundColor,

        // The color for text/icons displayed on top of the surface.
        onSurface: AppColors.primary,

        // The color used for indicating errors (e.g., in TextFields).
        error: Colors.red,

        // Color for content on top of error backgrounds.
        onError: Colors.white,
      ),

      /// --- Component-Specific Theming ---


      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        //surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),

      switchTheme: SwitchThemeData(
        // Removes the default border/outline around the switch track for a cleaner look.
        trackOutlineWidth: WidgetStateProperty.all(0),

        // Sets the color of the sliding "thumb" (the circle) to white in all states.
        thumbColor: WidgetStateProperty.all(AppColors.white),

        // Defines the "halo" or ripple effect color when the switch is pressed or hovered.
        overlayColor: WidgetStateProperty.all(AppColors.surfieGreen),

        // Manages the color of the track's border based on whether the switch is ON or OFF.
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.surfieGreen; // Border color when switch is ON.
          }
          return AppColors.silver;   // Border color when switch is OFF.
        }),

        // Manages the inner fill color of the track based on the switch state.
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.surfieGreen; // Background color when switch is ON.
          }
          return AppColors.silver;   // Background color when switch is OFF.
        }),
      ),

      // Global configuration for all InputDecorators (TextFields, FormFields).
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Enforces consistent corner radii across the app's inputs.
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        // Hint text styling to ensure legibility against the background.
        hintStyle: const TextStyle(color: Colors.grey),
      ),

      // The color used for widgets in a disabled state (e.g., Buttons).
      // .withValues() is the modern replacement for .withOpacity().
      disabledColor: AppColors.primary.withValues(alpha: 0.5),
    );
  }
}
