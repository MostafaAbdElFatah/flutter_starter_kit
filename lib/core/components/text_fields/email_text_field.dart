import 'package:flutter/material.dart';

import '../../assets/localization_keys.dart';
import '../../utils/validators/email_validator.dart';
import 'custom_text_field.dart';

/// A specialized text field widget tailored for email input.
///
/// This widget extends [StatelessWidget] and leverages the [CustomTextField]
/// to provide a pre-configured text field optimized for email entry. It includes
/// built-in validation to ensure the input conforms to standard email formats.
/// Additionally, it supports customization through various parameters such as
/// icons, read-only mode, callbacks, and more.
class EmailTextField extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// If true, the text field is read-only.
  final bool? readOnly;

  /// A widget to display before the input area, typically an icon.
  final Widget? prefixIcon;

  /// A widget to display after the input area, typically an icon.
  final Widget? suffixIcon;

  /// The file path of an SVG icon to display before the input area.
  final String? prefixSVGIcon;

  /// The file path of an SVG icon to display after the input area.
  final String? suffixSVGIcon;

  /// Callback invoked when the form is saved.
  final ValueChanged<String?>? onSaved;

  /// Callback invoked when the text changes.
  final ValueChanged<String>? onChanged;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// The action button to display on the keyboard.
  final TextInputAction? textInputAction;

  // ================================
  //        Constructor
  // ================================

  /// Creates an [EmailTextField] with the given parameters.
  ///
  /// All parameters are optional and allow for customization of the email text field's
  /// appearance and behavior.
  const EmailTextField({
    super.key,
    this.readOnly,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixSVGIcon,
    this.suffixSVGIcon,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.textInputAction,
  });

  // ================================
  //            Build
  // ================================

  /// Builds the [EmailTextField] widget.
  ///
  /// This method constructs a [CustomTextField] configured specifically for email input.
  /// It sets the appropriate keyboard type, autofill hints, and validation logic to ensure
  /// the entered text is a valid email address.
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      maxLines: 1,
      readOnly: readOnly,
      onSaved: onSaved,
      onChanged: onChanged,
      controller: controller,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixSVGIcon: prefixSVGIcon,
      suffixSVGIcon: suffixSVGIcon,
      hintText: LocalizationKeys.email,
      labelText: LocalizationKeys.email,
      textInputAction: textInputAction,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [
        AutofillHints.email,
        AutofillHints.username,
        AutofillHints.telephoneNumber,
        AutofillHints.telephoneNumberDevice,
      ],
      validator: EmailValidator.validateEmail,
    );
  }

  // ================================
  //     Private Helper Methods
  // ================================

  // Add any private helper methods here if needed in the future.
}
