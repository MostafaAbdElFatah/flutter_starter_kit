import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays an SVG icon with customizable properties.
///
/// The [SvgIcon] widget allows you to display SVG assets with optional
/// customization such as size, padding, and enabled state. When [isEnabled]
/// is set to `false`, the icon appears with a greyed-out effect.
///
/// Example usage:
/// ```dart
/// SvgIcon(
///   svgAssetPath: 'assets/icons/sample_icon.svg',
///   size: 24.0,
///   isEnabled: false,
///   padding: const EdgeInsets.all(8.0),
/// )
/// ```
class SvgIcon extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The file path to the SVG asset.
  final String svgAssetPath;

  /// The width and height of the SVG icon.
  final double? size;

  /// The width of the SVG icon.
  final double? width;

  /// The height of the SVG icon.
  final double? height;

  /// Determines whether the icon is enabled.
  ///
  /// When set to `false`, the icon is displayed with a greyed-out effect.
  final bool isEnabled;

  /// The padding around the SVG icon.
  ///
  /// If not specified, defaults to `EdgeInsets.zero`.
  final EdgeInsetsGeometry padding;

  /// The color to apply to the SVG icon when [isEnabled] is `true`.
  ///
  /// If not specified, the icon uses the default color defined in the SVG asset.
  final Color? color;

  /// The color to apply to the SVG icon when [isEnabled] is `false`.
  ///
  /// If not specified, the icon uses the default color Colors.grey.
  final Color? disableColor;

  // ================================
  //        Constructor
  // ================================

  /// Creates an [SvgIcon] widget.
  ///
  /// The [svgAssetPath] parameter must not be null.
  const SvgIcon({
    super.key,
    required this.svgAssetPath,
    this.size,
    this.width,
    this.height,
    this.isEnabled = true,
    this.padding = EdgeInsets.zero,
    this.disableColor,
    this.color,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // Determine the color filter based on the enabled state.
    final ColorFilter? colorFilter = isEnabled
        ? null
        : ColorFilter.mode(
        color ?? disableColor ?? Colors.grey, BlendMode.srcIn);
    final svgIcon = SvgPicture.asset(
      svgAssetPath,
      height: size,
      width: size,
      colorFilter: colorFilter,
      // Optionally handle loading and error states.
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: width ?? size,
        height: height ?? size,
        child: const CircularProgressIndicator(),
      ),
    );
    return Padding(
      padding: padding,
      child: svgIcon,
    );
  }
}
