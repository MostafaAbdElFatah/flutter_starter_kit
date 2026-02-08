import '../../core.dart';

/// A customizable stadium-shaped container for displaying a text label.
///
/// [StadiumTextContainer] provides a container with rounded edges (stadium shape),
/// optional border, and customizable properties such as width, height, padding, margin,
/// and text styling.
///
/// Example usage:
/// ```dart
/// StadiumTextContainer(
///   label: 'Hello, World!',
///   background: Colors.blue,
///   textColor: Colors.white,
///   borderColor: Colors.black,
///   borderWidth: 2,
/// )
/// ```
class StadiumTextContainer extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The text label to display inside the container.
  final String label;

  /// The width of the container. If not specified, it adapts to child or parent constraints.
  final double? width;

  /// The height of the container. If not specified, it adapts to child or parent constraints.
  final double? height;

  /// The color of the text label.
  final Color? textColor;

  /// Custom text style for the label.
  final TextStyle? textStyle;

  /// The maximum number of lines for the text label.
  final int? maxLines;

  /// The width of the border. Defaults to `1` if [borderColor] is provided.
  final double? borderWidth;

  /// The background color of the container.
  final Color background;

  /// The color of the border. If `null`, no border will be drawn.
  final Color? borderColor;

  /// The margin around the container.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the container.
  final EdgeInsetsGeometry? padding;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [StadiumTextContainer].
  ///
  /// - [background] is required and defines the background color of the container.
  /// - [label] is the text displayed inside the container.
  /// - Optional parameters like [borderColor], [borderWidth], [textColor],
  ///   [textStyle], [width], [height], [padding], and [margin] allow customization.
  const StadiumTextContainer({
    super.key,
    required this.label,
    required this.background,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.textStyle,
    this.textColor,
    this.maxLines,
    this.borderWidth,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sets the width of the container.
      width: width,

      // Sets the height of the container.
      height: height,

      // Applies margin around the container.
      margin: margin,

      // Applies padding inside the container.
      padding: padding,

      // Defines the decoration of the container.
      decoration: ShapeDecoration(
        // Sets the background color of the container.
        color: background,

        // Defines the shape and border of the container.
        shape: StadiumBorder(
          side: BorderSide(
            // If no [borderColor] is provided, use the background color.
            color: borderColor ?? background,
            // Uses the provided border width or defaults to `1`.
            width: borderWidth ?? 1,
          ),
        ),
      ),

      // Displays the label text inside the container.
      child: Text(
        label, // The label text to display.
        maxLines: maxLines, // Limits the number of lines.
        overflow: TextOverflow.ellipsis, // Adds ellipsis if the text overflows.
        // Applies text styling.
        style: textStyle ??
            AppColors.white.medium(fontSize: 14).copyWith(color: textColor),
      ),
    );
  }

  // ================================
  //        Helper Methods
  // ================================
}
