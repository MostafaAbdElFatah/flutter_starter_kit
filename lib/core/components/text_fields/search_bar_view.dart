import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/extensions/text_styles/color_text_style_extensions.dart';

import '../../constants/app_colors.dart';

/// A customizable search field widget with optional styling and functionality.
///
/// The [SearchBar] provides flexibility in appearance and behavior,
/// allowing for customization of borders, hint text, text styles, and validation.
/// It supports features like prefix/suffix icons, max length, and multi-line input.
class SearchBarView extends StatefulWidget {
  /// Determines whether the text field should have a filled background.
  final bool filled;

  /// The maximum number of characters allowed in the text field.
  final int? maxLength;

  /// The maximum number of lines for the text field.
  /// If null, the text field will have a single line unless [expands] is true.
  final int? maxLines;

  /// An optional widget to display at the end of the text field.
  final Widget? prefixIcon;

  /// If true, the text field will have no border.
  final bool hasNoBorder;

  /// The hint text displayed inside the text field when it is empty.
  final String? hintText;

  /// The style of the input text.
  final TextStyle? textStyle;

  /// The base fill color of the decoration's container color.
  final Color? fillColor;

  /// The type of keyboard to display for the text field.
  final TextInputType? inputType;

  /// The action button on the keyboard (e.g., "Search", "Done").
  final TextInputAction? textInputAction;

  /// Callback function triggered when the text field is tapped.
  final GestureTapCallback? onTap;

  /// Callback function triggered when the text in the field changes.
  final ValueChanged<String>? onChanged;

  /// Callback function triggered when the editing of the text field is complete.
  final VoidCallback? onEditingComplete;

  /// Callback function triggered when the user submits the text field.
  final ValueChanged<String>? onSubmitted;

  /// The controller managing the text being edited.
  final TextEditingController? controller;

  /// Creates a [SearchBar] widget.
  ///
  /// The [hintText] and [controller] are optional.
  /// The [filled] and [hasNoBorder] parameters default to `true` and `false`, respectively.
  const SearchBarView({
    super.key,
    this.filled = true,
    this.maxLength,
    this.maxLines,
    this.prefixIcon,
    this.fillColor,
    this.hasNoBorder = false,
    this.hintText,
    this.textStyle,
    this.inputType,
    this.textInputAction,
    this.onTap,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  bool _isHiddenClear = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Determine the type of keyboard to display.
      keyboardType: widget.inputType,

      // Set the maximum number of characters allowed.
      maxLength: widget.maxLength,

      // Set the maximum number of lines for the text field.
      maxLines: widget.maxLines,

      // Associate the controller with the text field.
      controller: widget.controller,

      // Assign the onTap callback.
      //onTap: widget.onTap,

      // Assign the onEditingComplete callback.
      onEditingComplete: widget.onEditingComplete,

      // Assign the onSubmitted callback.
      onSubmitted: widget.onSubmitted,

      // Set the action button on the keyboard (defaults to "Search").
      textInputAction: widget.textInputAction ?? TextInputAction.search,

      // Assign the text style to the input text.
      style: widget.textStyle ?? AppColors.blackRussian.regular(fontSize: 16),

      // Assign the onChanged callback.
      onChanged: (value) {
        if (widget.onChanged != null) widget.onChanged!(value);
        if ((value.isEmpty && !_isHiddenClear) ||
            (value.isNotEmpty && _isHiddenClear)) {
          setState(() => _isHiddenClear = !_isHiddenClear);
        }
      },

      // Configure the decoration of the text field.
      decoration: InputDecoration(
        // Whether the text field should have a filled background.
        filled: widget.filled,

        // An optional widget to display at the start of the text field.
        prefixIcon: widget.prefixIcon,

        // An optional widget to display at the end of the text field.
        suffixIcon: _isHiddenClear
            ? null
            : IconButton(
                icon: Icon(
                  Icons.close,
                  size: 20,
                ),
                padding: const EdgeInsets.all(15),
                onPressed: () {
                  widget.controller?.text = '';
                  if (widget.onSubmitted != null) widget.onSubmitted!('');
                  setState(() => _isHiddenClear = !_isHiddenClear);
                },
              ),

        // The hint text displayed when the field is empty.
        hintText: widget.hintText,

        // The text style applied to the hint text.
        hintStyle: AppColors.spunPearl.bold(fontSize: 14),

        // Hides the character counter by replacing it with an empty widget.
        counter: const SizedBox.shrink(),

        // Disables the floating label behavior.
        floatingLabelBehavior: FloatingLabelBehavior.never,

        // Adds horizontal padding inside the text field.
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),

        // Sets the fill color of the text field.
        fillColor: widget.fillColor ?? AppColors.solitude,

        // Styles the error text.
        errorStyle: AppColors.fireEngineRed.medium(fontSize: 12),

        // Configures the border when an error occurs.
        errorBorder: _buildBorder(color: AppColors.fireEngineRed),

        // Configures the border when the text field is focused.
        focusedBorder: _buildBorder(color: AppColors.solitude),

        // Configures the default border.
        border: _buildBorder(color: AppColors.solitude),

        // Configures the border when the text field is disabled.
        disabledBorder: _buildBorder(color: AppColors.solitude),

        // Configures the border when the text field is enabled.
        enabledBorder: _buildBorder(color: AppColors.solitude),
      ),
    );
  }

  /// Builds an [InputBorder] based on the [widget.hasNoBorder] flag and provided [color].
  ///
  /// If [widget.hasNoBorder] is `true`, returns [InputBorder.none].
  /// Otherwise, returns an [OutlineInputBorder] with rounded corners and no border side.
  InputBorder _buildBorder({required Color color}) {
    if (widget.hasNoBorder) {
      return InputBorder.none;
    } else {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), // Stadium shape
        borderSide: BorderSide.none, // No border side
      );
    }
  }
}
