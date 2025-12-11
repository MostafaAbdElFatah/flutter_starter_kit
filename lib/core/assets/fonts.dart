import 'dart:ui';

/// This class is used to store all the font families.
///
/// By using this class, we can avoid using hardcoded strings in the code.
/// This makes it easier to manage and update the font families.
///
/// Example:
/// ```dart
/// Text(
///   'Hello World',
///   style: TextStyle(fontFamily: Fonts.primary),
/// );
/// ```
abstract class Fonts {
  // Private constructor to prevent instantiation.
  Fonts._();
  static const String primary = "primary";
}


/// A centralized class that holds all font weight constants used in the application.
///
/// Organizing font weights in this manner promotes maintainability
/// and prevents typos by providing a single source of truth for font weight values.
abstract class FontWeights {
  FontWeights._(); // Private constructor to prevent instantiation

  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}