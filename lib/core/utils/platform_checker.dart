import 'dart:io';
import 'package:injectable/injectable.dart';

/// Helper class to check platform, making it testable
@lazySingleton
class PlatformChecker {
  const PlatformChecker();

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;
  bool get isMobile => Platform.isIOS || Platform.isAndroid;
}