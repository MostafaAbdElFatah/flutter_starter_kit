import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

import 'platform_checker.dart';

/// A service that provides information about the user's device.
///
/// This class abstracts the platform-specific details of retrieving device
/// information using the `device_info_plus` package. It is designed to be
/// injected as a dependency wherever device information is needed.
@LazySingleton()
class DeviceServices {
  final PlatformChecker _platformChecker;
  final DeviceInfoPlugin _deviceInfoPlugin;

  /// Creates an instance of [DeviceServices].
  ///
  /// Requires a [PlatformChecker] instance to be injected, which is typically
  /// Requires a [DeviceInfoPlugin] instance to be injected, which is typically
  /// provided by a dependency injection framework.
  DeviceServices({
    required PlatformChecker platformChecker,
    required DeviceInfoPlugin deviceInfoPlugin,
  }) : _platformChecker = platformChecker,
       _deviceInfoPlugin = deviceInfoPlugin;

  /// Returns the device model identifier.
  ///
  /// For iOS, this returns the `utsname.machine` value (e.g., "iPhone13,2").
  /// For Android, this returns the `device` value (e.g., "Pixel 5").
  /// Returns `null` for unsupported platforms.
  Future<String?> getDeviceModel() async {
    if (_platformChecker.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.utsname.machine;
    } else if (_platformChecker.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.device;
    }
    return null;
  }
}
