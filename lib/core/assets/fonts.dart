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

}
