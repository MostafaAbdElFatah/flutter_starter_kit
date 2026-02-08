import '../../core.dart';

/// A custom outlined button widget with support for loading states and customizable styles.
///
/// This widget provides a flexible outlined button with options for:
/// - Custom labels.
/// - Loading states (displays a spinner when loading).
/// - Custom text styles, colors, and padding.
/// - Optional max lines and text overflow handling.
///
/// Example usage:
/// ```dart
/// FlexibleOutlinedButton(
///   label: 'Cancel',
///   onPressed: () {
///     print('Button pressed');
///   },
///   isLoading: false,
///   titleColor: Colors.red,
/// )
/// ```
class FlexibleOutlinedButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The label (text) displayed on the button.
  final String label;

  /// Whether the button is in a loading state (displays a spinner if true).
  final bool isLoading;

  /// The maximum number of lines for the button's label text.
  final int? maxLines;

  /// The color of the button's label text.
  final Color? textColor;

  /// The text style for the button's label.
  final TextStyle? textStyle;

  /// The padding around the button's content.
  final EdgeInsetsGeometry? padding;

  /// The custom button style (overrides default styles if provided).
  final ButtonStyle? buttonStyle;

  /// Callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [FlexibleOutlinedButton] with the given parameters.
  ///
  /// - [label]: The label (text) displayed on the button.
  /// - [isLoading]: Whether the button is in a loading state (default: `false`).
  /// - [maxLines]: The maximum number of lines for the button's label text.
  /// - [textColor]: The color of the button's label text.
  /// - [textStyle]: The text style for the button's label.
  /// - [padding]: The padding around the button's content.
  /// - [buttonStyle]: The custom button style (overrides default styles if provided).
  /// - [onPressed]: Callback function triggered when the button is pressed.
  const FlexibleOutlinedButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.maxLines,
    this.textColor,
    this.textStyle,
    this.padding,
    this.buttonStyle,
    this.onPressed,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // If the button is in a loading state, display a progress spinner.
    if (isLoading) {
      return Center(
          child: CustomLoadingIndicator(
            colors: textColor == null ? null : [textColor!],
          ));
    }

    // Otherwise, display the outlined button.
    return OutlinedButton(
      // Handle button press events.
      onPressed: onPressed,
      // Apply custom button style if provided.
      style: buttonStyle,
      child: Padding(
        // Apply custom or default padding.
        padding: padding ?? _defaultPadding(),
        child: Text(
          label,
          // Limit the number of lines for the label.
          maxLines: maxLines,
          // Handle text overflow with ellipsis.
          overflow: TextOverflow.ellipsis,
          // Apply custom or default text style.
          style: _textStyle(context),
        ),
      ),
    );
  }

  // ================================
  //        Helper Methods
  // ================================

  /// Returns the text style, combining custom and default styles.
  TextStyle _textStyle(BuildContext context) {
    return textStyle ??
        TextStyle().medium(
            fontSize: 16, color: textColor ?? Theme.of(context).primaryColor);
  }

  /// Returns the default padding for the button's content.
  EdgeInsetsGeometry _defaultPadding() {
    return const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 5,
    );
  }
}
