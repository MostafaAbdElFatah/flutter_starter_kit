import '../../core.dart';


/// A customizable button widget that displays an SVG icon.
///
/// The [SvgIconButton] widget allows you to create a tappable button
/// with an SVG icon. It supports customization options such as size,
/// padding, border radius, and custom shapes. Additionally, it handles
/// enabled and disabled states based on the presence of an [onTap] callback.
///
/// Example usage:
/// ```dart
/// SvgIconButton(
///   svgAssetPath: 'assets/icons/download.svg',
///   size: 30.0,
///   onTap: () {
///     // Handle tap
///   },
///   borderRadius: BorderRadius.circular(12),
/// )
/// ```
class SvgIconButton extends StatelessWidget {

  // ================================
  //        Widget Parameters
  // ================================

  /// The file path to the SVG asset.
  final String svgAssetPath;

  /// The width and height of the SVG icon.
  ///
  /// Defaults to 24.0 if not specified.
  final double size;

  /// The color to apply to the SVG icon when [isEnabled] is `true`.
  ///
  /// If not specified, the icon uses the default color defined in the SVG asset.
  final Color? color;


  /// The border radius of the button.
  ///
  /// If [customShape] is provided, [borderRadius] will be ignored.
  final BorderRadius? borderRadius;

  /// The custom shape of the button.
  ///
  /// Overrides [borderRadius] if provided.
  final ShapeBorder? customShape;

  /// Callback function executed when the button is tapped.
  ///
  /// If [onTap] is null, the button is considered disabled.
  final GestureTapCallback? onTap;

  /// The padding around the SVG icon.
  ///
  /// Defaults to `EdgeInsets.all(8.0)` if not specified.
  final EdgeInsetsGeometry padding;


  // ================================
  //        Constructor
  // ================================


  /// Creates an [SvgIconButton].
  ///
  /// The [svgAssetPath] parameter must not be null.
  const SvgIconButton({
    super.key,
    required this.svgAssetPath,
    this.size = 24.0,
    this.borderRadius,
    this.customShape,
    this.onTap,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // Determine if the button is enabled based on the presence of onTap callback.
    final bool isEnabled = onTap != null;

    // Define the border radius, prioritizing customShape if provided.
    final ShapeBorder shape = customShape ??
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        );

    return InkWell(
      onTap: onTap,
      customBorder: shape,
      borderRadius: borderRadius,
      child: SvgIcon(
        svgAssetPath: svgAssetPath,
        size: size,
        color: color,
        padding: padding,
        isEnabled: isEnabled,
      ),
    );
  }
}

