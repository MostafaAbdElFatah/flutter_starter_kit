import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../utils/validators/password_validator.dart';
import 'custom_text_field.dart';

/// A specialized text field widget tailored for password input.
///
/// This widget extends [StatefulWidget] to manage the visibility of the password
/// and the focus state. It leverages [CustomTextField] to provide a secure input
/// field with built-in validation and customization options such as icons,
/// callbacks, and styling. Users can toggle the visibility of the entered password
/// using the suffix icon. Additionally, the widget responds visually to focus
/// changes by altering icon colors.
class PasswordTextField extends StatefulWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Determines whether the text field is filled with a background color.
  final bool? filled;

  /// The text displayed above the text field as a label.
  final String? labelText;

  /// The placeholder text displayed inside the text field when it is empty.
  final String? hintText;

  /// The size of the prefix icon.
  final double? iconSize;

  /// The icon displayed before the input area. Defaults to [Icons.lock_outline].
  final IconData prefixIcon;

  /// The style to apply to the hint text.
  final TextStyle? hintStyle;

  /// If true, displays an SVG icon as the prefix icon instead of the default [prefixIcon].
  final bool isPrefixIcon;

  /// The action button to display on the keyboard (e.g., next, done).
  final TextInputAction? textInputAction;

  /// Callback invoked when the form is saved.
  final ValueChanged<String?>? onSaved;

  /// Callback invoked when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback invoked when the text field is tapped.
  final GestureTapCallback? onTap;

  /// Callback invoked when a tap occurs outside the text field.
  final TapRegionCallback? onTapOutside;

  /// Callback invoked when the user finishes editing.
  final VoidCallback? onEditingComplete;

  /// Callback invoked when the user submits the field (e.g., presses enter).
  final ValueChanged<String>? onFieldSubmitted;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the behavior of the floating label.
  final FloatingLabelBehavior? floatingLabelBehavior;

  /// Validation logic for the input.
  final String? Function(String? value)? validator;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [PasswordTextField] with the given parameters.
  ///
  /// All parameters are optional except [prefixIcon], which defaults to [Icons.lock_outline].
  /// This widget provides a secure input field for password entry with customization options
  /// for icons, styling, and validation.
  const PasswordTextField({
    super.key,
    this.hintText,
    this.iconSize,
    this.hintStyle,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.labelText,
    this.controller,
    this.floatingLabelBehavior,
    this.prefixIcon = Icons.lock_outline,
    this.textInputAction,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.isPrefixIcon = false,
    this.filled,
  });

  // ================================
  //          State Creation
  // ================================

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

/// The state class for [PasswordTextField].
///
/// Manages the visibility of the password and handles user interactions.
/// It also detects focus changes to update the UI accordingly.
class _PasswordTextFieldState extends State<PasswordTextField> {
  /// Determines whether the password is obscured.
  bool _isPasswordHidden = true;

  /// FocusNode to monitor focus changes.
  final FocusNode _focusNode = FocusNode();

  /// Tracks whether the text field is currently focused.
  bool _isFocused = false;

  /// Internal controller for managing the password input.
  /// If a controller is provided via [PasswordTextField], it uses that instead.
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    // Initialize the controller. Use the provided controller or create a new one.
    _passwordController = widget.controller ?? TextEditingController();

    // Add listener to FocusNode to handle focus changes.
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    // Remove the focus change listener.
    _focusNode.removeListener(_handleFocusChange);

    // Dispose the FocusNode.
    _focusNode.dispose();

    // Dispose the internal controller if it was created internally.
    if (widget.controller == null) {
      _passwordController.dispose();
    }

    super.dispose();
  }

  // ================================
  //            Build
  // ================================

  /// Builds the [PasswordTextField] widget.
  ///
  /// Constructs a [CustomTextField] configured specifically for password input.
  /// It includes a prefix icon (optionally an SVG icon), a suffix icon to toggle
  /// password visibility, and validation logic to ensure password strength.
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      maxLines: 1,
      focusNode: _focusNode,
      controller: _passwordController,
      obscureText: _isPasswordHidden,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      autofillHints: const [AutofillHints.password],
      hintText: widget.hintText ?? '********',
      filled: widget.filled,
      hintStyle: widget.hintStyle,
      labelText: widget.labelText,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      prefixIcon: !widget.isPrefixIcon
          ? null
          : Icon(widget.prefixIcon, size: widget.iconSize),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
          color: _isFocused
              ? Theme.of(context).primaryColor
              : AppColors.silver, // Change color based on focus
        ),
        onPressed: _togglePasswordVisibility,
      ),
      validator: widget.validator ?? PasswordValidator.validatePassword,
      // Custom Password Requirements
      // validator: (value) => PasswordValidator.validatePassword(
      //   value,
      //   minLength: 12,
      //   requireSpecialChar: false,
      // ),
    );
  }

  // ================================
  //     Private Helper Methods
  // ================================

  /// Toggles the visibility of the password.
  ///
  /// Updates the state to either obscure or reveal the password text.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  /// Handles focus changes by updating the [_isFocused] state.
  ///
  /// This method is called whenever the focus state changes.
  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }
}
