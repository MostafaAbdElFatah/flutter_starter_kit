import 'dart:io';

/// Helper class to check platform, making it testable
class PlatformChecker {
  const PlatformChecker();

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
}