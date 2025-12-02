/// This class is used to store all the image assets paths.
///
/// By using this class, we can avoid using hardcoded strings in the code.
/// This makes it easier to manage and update the image assets paths.
///
/// Example:
/// ```dart
/// Image.asset(Images.logo);
/// ```
abstract class Images {
  // Private constructor to prevent instantiation.
  Images._();

  static const String logo = 'assets/images/logo.png';
}
