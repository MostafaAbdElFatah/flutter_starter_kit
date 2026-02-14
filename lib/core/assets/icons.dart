/// This class is used to store all the icon assets paths.
///
/// By using this class, we can avoid using hardcoded strings in the code.
/// This makes it easier to manage and update the icon assets paths.
///
/// Example:
/// ```dart
/// SvgPicture.asset(SvgIcons.logo);
/// ```
abstract class SvgIcons {
  // Private constructor to prevent instantiation.
  SvgIcons._();

  // ===========================================================================
  // Base paths
  // ===========================================================================

  static const String _iconsBasePath = 'assets/icons';
  static const String _commonPath = '$_iconsBasePath/common';

  // ===========================================================================
  // common
  // ===========================================================================

  static const critical = "$_commonPath/critical.svg";
  static const shieldFail = "$_commonPath/shield-fail.svg";
  static const shieldFailBorder = "$_commonPath/shield-fail-border.svg";
  static const success = "$_commonPath/success.svg";
  static const success2 = "$_commonPath/success2.svg";
  static const warning = "$_commonPath/warning.svg";
  static const halfStar = "$_commonPath/half_star.svg";
  static const starBorder = "$_commonPath/star_border.svg";
  static const whiteStar = "$_commonPath/white-star.svg";
  static const yellowStar = "$_commonPath/yellow-star.svg";
}
