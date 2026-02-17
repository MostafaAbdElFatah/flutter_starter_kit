import 'package:flutter/material.dart';

import '../../assets/fonts.dart';
import 'text_style_extensions.dart';

/// Extension on [Color] to provide convenient methods for creating [TextStyle]s
/// with various font weights.
///
/// This extension allows you to create [TextStyle] instances directly from a [Color],
/// specifying the desired font weight, size, and other attributes.
///
/// Example Usage:
/// ```dart
/// TextStyle style = Colors.blue.bold(fontSize: 16, setSp: true);
/// ```
extension CustomTextStylesThemeExtensions on Color {
  /// Creates a [TextStyle] with the specified parameters.
  ///
  /// - [fontSize]: The size of the font.
  /// - [fontWeight]: The weight of the font. Defaults to [FontWeights.regular].
  /// - [setSp]: If `true`, applies scalable pixels to [fontSize] (requires a responsive package like `flutter_screenutil`).
  /// - [fontFamily]: The font family to use. Defaults to [Fonts.ibmPlexSanaArabic] if not provided.
  ///
  /// Returns a [TextStyle] configured with the provided parameters.
  TextStyle textStyle({
    bool? setSp,
    double? fontSize,
    FontWeights? fontWeight,
    FontFamily? fontFamily,
  }) {
    return AppTextStyle.textStyle(
      // Uses the [Color] instance on which this extension is called
      color: this,
      setSp: setSp,
      fontSize: fontSize,
      fontWeight: fontWeight,
      // Defaults to a specific font family
      fontFamily: fontFamily ?? FontFamily.primary,
    );
  }

  /// Creates a [TextStyle] with a thin font weight.
  ///
  /// Thin is the least thick font weight.
  TextStyle thin({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.thin,
      );

  /// Creates a [TextStyle] with an extra-light font weight.
  TextStyle extraLight({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.extraLight,
      );

  /// Creates a [TextStyle] with a light font weight.
  TextStyle light({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.light,
      );

  /// Creates a [TextStyle] with a regular (normal) font weight.
  ///
  /// Regular is the standard font weight.
  TextStyle regular({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.regular,
      );

  /// Creates a [TextStyle] with a medium font weight.
  TextStyle medium({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.medium,
      );

  /// Creates a [TextStyle] with a semi-bold font weight.
  TextStyle semiBold({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.semiBold,
      );

  /// Creates a [TextStyle] with a bold font weight.
  TextStyle bold({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.bold,
      );

  /// Creates a [TextStyle] with an extra-bold font weight.
  TextStyle extraBold({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.extraBold,
      );

  /// Creates a [TextStyle] with a black (heaviest) font weight.
  ///
  /// Black is the most thick font weight.
  TextStyle black({
    bool? setSp,
    double? fontSize,
    FontFamily? fontFamily,
  }) =>
      textStyle(
        fontSize: fontSize,
        setSp: setSp,
        fontFamily: fontFamily,
        fontWeight: FontWeights.black,
      );
}
