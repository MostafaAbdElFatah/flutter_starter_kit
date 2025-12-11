import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../constants/app_colors.dart';
import '../../../core/extensions/text_styles/color_text_style_extensions.dart';



/// A custom widget for entering OTP (One-Time Password) codes.
///
/// This widget uses the `Pinput` package to provide a customizable OTP input field.
/// It supports:
/// - Customizable length for the OTP code.
/// - Autofocus and clipboard integration.
/// - Custom themes for default, focused, submitted, and error states.
/// - Haptic feedback and validation.
///
/// Example usage:
/// ```dart
/// OTPInputField(
///   length: 6,
///   onCompleted: (value) {
///     print('OTP entered: $value');
///   },
/// )
/// ```
class OtpInputField extends StatelessWidget {
  /// The length of the OTP code (default is 6).
  final int length;

  /// The focus node for the OTP input field.
  final FocusNode? focusNode;

  /// The controller for the OTP input field.
  final TextEditingController? controller;

  /// Callback function triggered when the OTP code is fully entered.
  final ValueChanged<String>? onCompleted;

  /// Creates an [OtpInputField] with the given parameters.
  ///
  /// - [length]: The length of the OTP code (default is 6).
  /// - [focusNode]: The focus node for the OTP input field.
  /// - [controller]: The controller for the OTP input field.
  /// - [onCompleted]: Callback function triggered when the OTP code is fully entered.
  const OtpInputField({
    super.key,
    this.length = 6,
    this.focusNode,
    this.controller,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // Define the default pin theme for the OTP input field.
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.silver),
      ),
    );

    // Return the Pinput widget with customized configurations.
    return Pinput(
      // Set the length of the OTP code.
      length: length,

      // Automatically focus on the input field when it is displayed.
      autofocus: true,

      // Set the text controller for the input field.
      controller: controller,

      // Set the focus node for the input field.
      focusNode: focusNode,

      // Handle OTP completion when all digits are entered.
      onCompleted: onCompleted,

      // Apply the default pin theme to the input field.
      defaultPinTheme: defaultPinTheme,

      // Set the error text style for validation messages.
      errorTextStyle: Colors.red.medium(fontSize: 12),

      // Add spacing between OTP input fields.
      separatorBuilder: (index) => const SizedBox(width: 8),

      // Disable auto-validation for the input field.
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'LocalizationKeys.kFieldNullError';
        }
        return null;
      },

      // Handle clipboard content by pasting it into the input field.
      onClipboardFound: (value) => controller?.text = value,

      // Provide haptic feedback when a digit is entered.
      hapticFeedbackType: HapticFeedbackType.lightImpact,

      // Customize the cursor appearance for the input field.
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),

      // Customize the appearance of the input field when it is focused.
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),

      // Customize the appearance of the input field when the OTP is submitted.
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: const Color.fromRGBO(243, 246, 249, 0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 2),
        ),
      ),

      // Customize the appearance of the input field when there is an error.
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent, width: 2),
      ),
    );
  }
}