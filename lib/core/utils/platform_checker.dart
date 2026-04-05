import 'dart:io';

import 'package:injectable/injectable.dart';

/// Lightweight, injectable platform checker to keep platform branching testable.
@lazySingleton
class PlatformChecker {
  const PlatformChecker();

  /// True when running on iOS.
  bool get isIOS => Platform.isIOS;

  /// True when running on Android.
  bool get isAndroid => Platform.isAndroid;

  /// True when running on a mobile OS (iOS or Android).
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
}
