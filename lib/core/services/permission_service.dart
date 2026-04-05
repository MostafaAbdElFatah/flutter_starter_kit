import 'package:permission_handler/permission_handler.dart';

/// Permission-related helpers for the app.
class PermissionService {
  /// Requests location permission if it is not already granted.
  ///
  /// Returns the final [PermissionStatus] after any prompt.
  static Future<PermissionStatus> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      return await Permission.location.request();
    }
    return status;
  }
}
