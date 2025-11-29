import 'package:flutter/foundation.dart';

class Debug {
  Debug._();

  static void log(String message) {
    if (kDebugMode) print("[DEBUG] $message");
  }
}
