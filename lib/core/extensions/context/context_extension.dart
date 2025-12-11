import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void hideKeyboard() {
    //FocusManager.instance.primaryFocus?.unfocus();
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
