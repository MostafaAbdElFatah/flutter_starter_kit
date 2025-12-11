import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/text_styles/color_text_style_extensions.dart';

import '../../constants/app_colors.dart';
import '../general/svg_icon.dart' show SvgIcon;

/// A customizable text input field that provides extensive configuration options
/// for enhanced flexibility and styling.
///
/// This widget extends [StatelessWidget] and encapsulates a [TextFormField],
/// allowing for customization of appearance, behavior, and functionality.
/// It supports features such as prefix/suffix icons (including SVG icons),
/// input validation, password obscuring, styling, and more.
///
/// **Note:** When [obscureText] is set to `true`, [maxLines] is automatically
/// enforced to `1` to comply with Flutter's [TextFormField] constraints.
class CustomTextField extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Determines whether the text field is filled with a background color.
  final bool? filled;

  /// The maximum number of characters that can be entered.
  final int? maxLength;

  /// Controls whether the text field is enabled or disabled.
  final bool? enabled;

  /// If true, the text field is read-only.
  final bool? readOnly;

  /// The maximum number of lines for the text field.
  ///
  /// **Note:** If [obscureText] is `true`, this value is overridden to `1`.
  final int? maxLines;

  /// The minimum number of lines for the text field.
  final int? minLines;

  /// Determines whether the text is obscured (e.g., for password fields).
  final bool obscureText;

  /// The character used to obscure the text.
  final String obscuringCharacter;

  /// The hint text displayed inside the text field when it is empty.
  final String? hintText;

  /// The label text displayed above the text field.
  final String? labelText;

  /// Determines whether the text field should expand to fill available space.
  final bool expands;

  /// A widget to display before the input area, typically an icon.
  final Widget? prefixIcon;

  /// A widget to display after the input area, typically an icon.
  final Widget? suffixIcon;

  /// The file path of an SVG icon to display before the input area.
  final String? prefixSVGIcon;

  /// The file path of an SVG icon to display after the input area.
  final String? suffixSVGIcon;

  /// The style to apply to the hint text.
  final TextStyle? hintStyle;

  /// Controls the focus of the text field.
  final FocusNode? focusNode;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// Callback invoked when the text field is tapped.
  final GestureTapCallback? onTap;

  /// Callback invoked when a tap occurs outside the text field.
  final TapRegionCallback? onTapOutside;

  /// Callback invoked when the user finishes editing.
  final VoidCallback? onEditingComplete;

  /// Callback invoked when the form is saved.
  final ValueChanged<String?>? onSaved;

  /// Callback invoked when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback invoked when the user submits the field (e.g., presses enter).
  final ValueChanged<String>? onFieldSubmitted;

  /// Hints for autofill services.
  final Iterable<String>? autofillHints;

  /// The action button to display on the keyboard.
  final TextInputAction? textInputAction;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the behavior of the floating label.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// Custom decoration for the text field.
  final InputDecoration? decoration;

  /// Validation logic for the input.
  final String? Function(String? value)? validator;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [CustomTextField] with the given parameters.
  ///
  /// All parameters are optional and allow for extensive customization
  /// of the text field's appearance and behavior.
  ///
  /// **Important:** If [obscureText] is set to `true`, [maxLines] is
  /// automatically enforced to `1` to comply with Flutter's [TextFormField]
  /// constraints.
  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixSVGIcon,
    this.suffixSVGIcon,
    this.hintStyle,
    this.onSaved,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.autofillHints,
    this.controller,
    this.labelText,
    this.floatingLabelBehavior,
    this.decoration,
    this.enabled,
    this.readOnly,
    this.filled,
    this.maxLength,
    this.onTap,
    this.focusNode,
    this.obscureText = false,
    this.expands = false,
    this.obscuringCharacter = '*',
  });

  // ================================
  //            Build
  // ================================

  /// Builds the [CustomTextField] widget.
  ///
  /// This method constructs a [TextFormField] with the provided configuration,
  /// applying default styles and handling the display of prefix/suffix icons,
  /// including SVG icons if specified.
  ///
  /// **Note:** If [obscureText] is `true`, [maxLines] is overridden to `1`.
  @override
  Widget build(BuildContext context) {
    // Enforce maxLines to 1 if obscureText is true to satisfy Flutter's constraints.
    final effectiveMaxLines = obscureText ? 1 : maxLines;

    return TextFormField(
      controller: controller,
      maxLines: effectiveMaxLines,
      minLines: minLines,
      maxLength: maxLength,
      expands: expands,
      enabled: enabled,
      focusNode: focusNode,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      keyboardType: keyboardType,
      readOnly: readOnly ?? false,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      onTapOutside: onTapOutside,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      style: AppColors.white.regular(fontSize: 16),
      decoration:
          decoration ??
          InputDecoration(
            filled: filled,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: floatingLabelBehavior,
            hintStyle: hintStyle,
            suffixIcon: suffixSVGIcon != null
                ? SvgIcon(svgAssetPath: suffixSVGIcon!)
                : suffixIcon,
            prefixIcon: prefixSVGIcon != null
                ? SvgIcon(svgAssetPath: prefixSVGIcon!)
                : prefixIcon,
          ),
    );
  }

  // ================================
  //     Private Helper Methods
  // ================================

  // Add any private helper methods here if needed in the future.
}
