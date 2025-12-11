import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../assets/localization_keys.dart';


class PhoneTextField extends StatelessWidget {
  final PhoneNumber? initialPhone;
  final ValueChanged<PhoneNumber>? onSaved;
  final ValueChanged<PhoneNumber>? onChanged;
  final TextEditingController? controller;
  const PhoneTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.controller,
    this.initialPhone,
  });

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      formatInput: true,
      onSaved: onSaved,
      ignoreBlank: true,
      initialValue: initialPhone,
      locale: context.locale.languageCode,
      onInputChanged: onChanged,
      textFieldController: controller,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      errorMessage: LocalizationKeys.kInvalidPhoneError,
      hintText: LocalizationKeys.phone,
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      keyboardType: TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputDecoration: InputDecoration(
        filled: false,
        hintText: LocalizationKeys.phone,
        labelText: LocalizationKeys.phone,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      autofillHints: const [
        AutofillHints.telephoneNumber,
        AutofillHints.telephoneNumberDevice,
      ],
    );
  }
}
