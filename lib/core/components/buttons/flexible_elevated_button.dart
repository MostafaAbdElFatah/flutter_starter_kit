import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../extensions/text_styles/color_text_style_extensions.dart';
import '../loading/custom_loading_indicator.dart';

/// A highly customizable elevated button widget with support for loading states,
/// text labels, or custom child widgets.
///
/// This widget provides a flexible elevated button with options for:
/// - Custom text labels or child widgets.
/// - Loading states (displays a spinner when loading).
/// - Custom text styles, colors, and padding.
/// - Optional max lines and text overflow handling for text labels.
///
/// Example usage with text label:
/// ```dart
/// FlexibleElevatedButton(
///   label: 'Submit',
///   onPressed: () {
///     print('Button pressed');
///   },
///   isLoading: false,
///   backgroundColor: Colors.blue,
/// )
/// ```
///
/// Example usage with custom child widget:
/// ```dart
/// FlexibleElevatedButton(
///   child: Row(
///     children: [
///       Icon(Icons.send),
///       SizedBox(width: 8),
///       Text('Submit'),
///     ],
///   ),
///   onPressed: () {
///     print('Button pressed');
///   },
///   isLoading: false,
///   backgroundColor: Colors.blue,
/// )
/// ```
class FlexibleElevatedButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The label (text) displayed on the button. If provided, `child` will be ignored.
  final String? label;

  /// The child widget to display inside the button. If `label` is provided, this will be ignored.
  final Widget? child;

  /// Whether the button is in a loading state (displays a spinner if true).
  final bool isLoading;

  /// The maximum number of lines for the button's label text (only applicable if `label` is provided).
  final int? maxLines;

  /// The color of the button's label text (only applicable if `label` is provided).
  final Color? textColor;

  /// The text style for the button's label (only applicable if `label` is provided).
  final TextStyle? textStyle;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The custom button style (overrides default styles if provided).
  final ButtonStyle? buttonStyle;

  /// Callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// The padding around the button's content.
  final EdgeInsetsGeometry? padding;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [FlexibleElevatedButton] with the given parameters.
  ///
  /// - [label]: The label (text) displayed on the button. If provided, `child` will be ignored.
  /// - [child]: The child widget to display inside the button. If `label` is provided, this will be ignored.
  /// - [isLoading]: Whether the button is in a loading state (default: `false`).
  /// - [maxLines]: The maximum number of lines for the button's label text (only applicable if `label` is provided).
  /// - [textColor]: The color of the button's label text (only applicable if `label` is provided).
  /// - [textStyle]: The text style for the button's label (only applicable if `label` is provided).
  /// - [backgroundColor]: The background color of the button.
  /// - [buttonStyle]: The custom button style (overrides default styles if provided).
  /// - [onPressed]: Callback function triggered when the button is pressed.
  /// - [padding]: The padding around the button's content.
  const FlexibleElevatedButton({
    super.key,
    this.label,
    this.child,
    this.isLoading = false,
    this.maxLines,
    this.textColor,
    this.textStyle,
    this.backgroundColor,
    this.buttonStyle,
    this.onPressed,
    this.padding,
  }) : assert(
         label != null || child != null,
         'Either label or child must be provided.',
       );

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // If the button is in a loading state, display a progress spinner.
    if (isLoading) {
      return Center(
        child: CustomLoadingIndicator(
          backgroundColor: backgroundColor,
          colors: [textColor ?? AppColors.white],
        ),
      );
    }

    // Otherwise, display the elevated button.
    return ElevatedButton(
      // Handle button press events.
      onPressed: onPressed,
      // Apply custom or default button style.
      style: _getButtonStyle(context),
      child: Padding(
        // Apply custom or default padding.
        padding: padding ?? _defaultPadding(),
        // Display the appropriate content (label or child).
        child: _getButtonContent(),
      ),
    );
  }

  // ================================
  //        Helper Methods
  // ================================

  /// Returns the appropriate content for the button (either a text label or a custom child widget).
  Widget _getButtonContent() {
    if (label != null) {
      return Text(
        label!,
        // Limit the number of lines for the label.
        maxLines: maxLines,
        // Handle text overflow with ellipsis.
        overflow: TextOverflow.ellipsis,
        // Apply custom or default text style.
        style: _textStyle,
      );
    } else {
      return child!; // Return the provided child widget.
    }
  }

  /// Returns the text style, combining custom and default styles (only applicable if `label` is provided).
  TextStyle get _textStyle {
    return textStyle ??
        AppColors.white.medium(fontSize: 16).copyWith(color: textColor);
  }

  /// Returns the button style, combining custom and default styles.
  ButtonStyle? _getButtonStyle(BuildContext context) {
    return buttonStyle ??
        Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: backgroundColor != null
              ? WidgetStateProperty.all<Color>(backgroundColor!)
              : null,
        );
  }

  /// Returns the default padding for the button's content.
  EdgeInsetsGeometry _defaultPadding() {
    return const EdgeInsets.symmetric(vertical: 15, horizontal: 5);
  }
}

/// A custom elevated button widget with support for loading states and customizable styles.
///
/// This widget provides a flexible elevated button with options for:
/// - Custom labels.
/// - Loading states (displays a spinner when loading).
/// - Custom text styles, colors, and padding.
/// - Optional max lines and text overflow handling.
///
/// Example usage:
/// ```dart
/// FlexibleElevatedButton(
///   label: 'Submit',
///   onPressed: () {
///     print('Button pressed');
///   },
///   isLoading: false,
///   backgroundColor: Colors.blue,
/// )
/// ```
class FlexibleElevatedButton2 extends StatelessWidget {
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

  /// The background color of the button.
  final Color? backgroundColor;

  /// The custom button style (overrides default styles if provided).
  final ButtonStyle? buttonStyle;

  /// Callback function triggered when the button is pressed.
  final VoidCallback? onPressed;

  /// The padding around the button's content.
  final EdgeInsetsGeometry? padding;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [FlexibleElevatedButton] with the given parameters.
  ///
  /// - [label]: The label (text) displayed on the button.
  /// - [isLoading]: Whether the button is in a loading state (default: `false`).
  /// - [maxLines]: The maximum number of lines for the button's label text.
  /// - [textColor]: The color of the button's label text.
  /// - [textStyle]: The text style for the button's label.
  /// - [backgroundColor]: The background color of the button.
  /// - [buttonStyle]: The custom button style (overrides default styles if provided).
  /// - [onPressed]: Callback function triggered when the button is pressed.
  /// - [padding]: The padding around the button's content.
  const FlexibleElevatedButton2({
    super.key,
    required this.label,
    this.isLoading = false,
    this.maxLines,
    this.textColor,
    this.textStyle,
    this.backgroundColor,
    this.buttonStyle,
    this.onPressed,
    this.padding,
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
          backgroundColor: backgroundColor,
          colors: [textColor ?? AppColors.white],
        ),
      );
    }

    // Otherwise, display the elevated button.
    return ElevatedButton(
      // Handle button press events.
      onPressed: onPressed,
      // Apply custom or default button style.
      style: _getButtonStyle(context),
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
          style: _textStyle,
        ),
      ),
    );
  }

  // ================================
  //        Helper Methods
  // ================================

  /// Returns the text style, combining custom and default styles.
  TextStyle get _textStyle {
    return textStyle ??
        AppColors.white.medium(fontSize: 16).copyWith(color: textColor);
  }


  /// Returns the button style, combining custom and default styles.
  ButtonStyle? _getButtonStyle(BuildContext context) {
    return buttonStyle ??
        Theme.of(context).elevatedButtonTheme.style?.copyWith(
          backgroundColor: backgroundColor != null
              ? WidgetStateProperty.all<Color>(backgroundColor!)
              : null,
        );
  }

  /// Returns the default padding for the button's content.
  EdgeInsetsGeometry _defaultPadding() {
    return const EdgeInsets.symmetric(vertical: 15, horizontal: 5);
  }
}
