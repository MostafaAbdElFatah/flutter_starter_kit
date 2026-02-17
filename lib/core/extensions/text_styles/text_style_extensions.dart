import '../../core.dart';

/// Extension on [TextStyle] to provide convenient methods for modifying [TextStyle]s
/// with various font weights.
///
/// This extension allows you to easily change the font weight, color, size, and font family
/// of existing [TextStyle] instances.
extension AppTextStyle on TextStyle {
  /// Makes the [TextStyle] thin.
  ///
  /// Thin is the least thick font weight.
  static TextStyle get defaultTextStyle => TextStyle();

  /// Creates a [TextStyle] with the specified parameters.
  ///
  /// - [fontSize]: The size of the font.
  /// - [fontWeight]: The weight of the font. Defaults to [FontWeights.regular].
  /// - [setSp]: If `true`, applies scalable pixels to [fontSize] (requires a responsive package like `flutter_screenutil`).
  /// - [fontFamily]: The font family to use. Defaults to [Fonts.ibmPlexSanaArabic] if not provided.
  ///
  /// Returns a [TextStyle] configured with the provided parameters.
  static TextStyle textStyle({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontWeights? fontWeight,
    FontFamily? fontFamily,
  }) {
    return defaultTextStyle.copyWith(
      // Uses the [Color] instance on which this extension is called
      color: color,
      fontWeight: fontWeight?.weight,
      // Applies scalable pixels if [setSp] is true
      fontSize: (setSp ?? true) ? fontSize?.sp : fontSize,
      // Defaults to a specific font family
      fontFamily: fontFamily?.name ?? FontFamily.primary.name,
    );
  }

  /// Makes the [TextStyle] thin.
  ///
  /// Thin is the least thick font weight.
  TextStyle thin({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.thin,
    );
  }

  /// Makes the [TextStyle] extra-light.
  ///
  /// Extra-light is slightly thicker than thin.
  TextStyle extraLight({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.extraLight,
    );
  }

  /// Makes the [TextStyle] light.
  ///
  /// Light is thinner than regular.
  TextStyle light({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.light,
    );
  }

  /// Makes the [TextStyle] regular (normal).
  ///
  /// Regular is the standard font weight.
  TextStyle regular({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.regular,
    );
  }

  /// Makes the [TextStyle] medium.
  ///
  /// Medium is slightly thicker than regular.
  TextStyle medium({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.medium,
    );
  }

  /// Makes the [TextStyle] semi-bold.
  ///
  /// Semi-bold is thicker than medium.
  TextStyle semiBold({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.semiBold,
    );
  }

  /// Makes the [TextStyle] bold.
  ///
  /// Bold is thicker than semi-bold.
  TextStyle bold({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.bold,
    );
  }

  /// Makes the [TextStyle] extra-bold.
  ///
  /// Extra-bold is thicker than bold.
  TextStyle extraBold({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.extraBold,
    );
  }

  /// Makes the [TextStyle] black (heaviest).
  ///
  /// Black is the most thick font weight.
  TextStyle black({
    bool? setSp,
    Color? color,
    double? fontSize,
    FontFamily? fontFamily,
  }) {
    return textStyle(
      color: color,
      setSp: setSp,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: FontWeights.black,
    );
  }
}
