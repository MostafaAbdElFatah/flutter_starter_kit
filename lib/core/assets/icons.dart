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
  // common
  // ===========================================================================

  static const critical = "assets/icons/common/critical.svg";
  static const shieldFail = "assets/icons/common/shield-fail.svg";
  static const shieldFailBorder = "assets/icons/common/shield-fail-border.svg";
  static const success = "assets/icons/common/success.svg";
  static const success2 = "assets/icons/common/success2.svg";
  static const warning = "assets/icons/common/warning.svg";

  static const halfStar = "assets/icons/common/half_star.svg";
  static const starBorder = "assets/icons/common/star_border.svg";
  static const whiteStar = "assets/icons/common/white-star.svg";
  static const yellowStar = "assets/icons/common/yellow-star.svg";
}
