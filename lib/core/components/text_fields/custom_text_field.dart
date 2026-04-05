import 'package:flutter/services.dart';

import '../../core.dart';

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
  final Widget? prefix;

  /// A widget to display after the input area, typically an icon.
  final Widget? suffix;

  /// A icon to display before the input area, typically an icon.
  final IconData? prefixIcon;

  /// A to to display after the input area, typically an icon.
  final IconData? suffixIcon;

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

  /// Optional input formatters to apply to the underlying [TextFormField].
  final List<TextInputFormatter>? inputFormatters;

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

  final EdgeInsetsGeometry? prefixPadding;
  final EdgeInsetsGeometry? suffixPadding;

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
    this.prefix,
    this.suffix,
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
    this.inputFormatters,
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
    this.prefixPadding,
    this.suffixPadding,
  });

  // ================================
  //            Build
  // ================================

  /// Builds the [CustomTextField]
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
    final suffixIcon = _suffix(context);
    final prefixIcon = _prefix(context);

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
      inputFormatters: inputFormatters,
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
      textAlignVertical: prefixIcon != null || suffixIcon != null
          ? TextAlignVertical.center
          : null,
      decoration:
          decoration ??
          InputDecoration(
            filled: filled,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: floatingLabelBehavior,
            hintStyle: hintStyle,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            // Add contentPadding to center the text vertically
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              // vertical: 5, // Adjust this value as needed
            ),
            // Reduce the constraints of the prefix icon container
            // prefixIconConstraints: BoxConstraints(
            //   minHeight: 40,
            // ),
            // suffixIconConstraints: BoxConstraints(
            //   minHeight: 40,
            // ),
          ),
    );
  }

  // ================================
  //     Private Helper Methods
  // ================================

  Widget? _suffix(BuildContext context) {
    if (suffixSVGIcon != null) {
      return SvgIcon(
        svgAssetPath: suffixSVGIcon!,
        padding: suffixPadding ?? EdgeInsets.all(10),
      );
    } else if (suffixIcon != null) {
      return Padding(
        padding: suffixPadding ?? EdgeInsets.all(10),
        child: Icon(suffixIcon),
      );
    }
    return suffix;
  }

  Widget? _prefix(BuildContext context) {
    if (prefixSVGIcon != null) {
      return SvgIcon(
        svgAssetPath: prefixSVGIcon!,
        padding: prefixPadding ?? EdgeInsets.all(10),
      );
    } else if (prefixIcon != null) {
      return Padding(
        padding: prefixPadding ?? EdgeInsets.all(10),
        child: Icon(prefixIcon),
      );
    }
    return prefix;
  }

  // Add any private helper methods here if needed in the future.
}
