import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../infrastructure/domain/entities/location.dart';
import 'permission_service.dart';

/// Location-related helpers for requesting permissions and fetching coordinates.
class LocationService {
  /// Gets the current GPS position if services and permissions allow it.
  ///
  /// Returns `null` when location services are disabled, permissions are denied,
  /// or the platform-specific permission check fails.
  static Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission.isDenied) return null;
    }

    if (permission.isDeniedForever) return null;

    final status = await PermissionService.requestLocationPermission();
    if (!status.isGranted && Platform.isAndroid) return null;

    final LocationSettings settings;
    if (kIsWeb) {
      settings = WebSettings(accuracy: LocationAccuracy.high);
    } else if (Platform.isAndroid) {
      settings = AndroidSettings(accuracy: LocationAccuracy.high);
    } else if (Platform.isIOS || Platform.isMacOS) {
      settings = AppleSettings(accuracy: LocationAccuracy.high);
    } else {
      settings = const LocationSettings(accuracy: LocationAccuracy.high);
    }

    return Geolocator.getCurrentPosition(locationSettings: settings);
  }

  /// Returns the last known position if available, otherwise `null`.
  static Future<Position?> getLastKnownPosition() =>
      Geolocator.getLastKnownPosition();
}

/// Convenience checks for [LocationPermission] values.
extension LocationPermissionExtension on LocationPermission {
  /// True when permission is temporarily denied.
  bool get isDenied => this == LocationPermission.denied;

  /// True when permission is permanently denied.
  bool get isDeniedForever => this == LocationPermission.deniedForever;
}


/// Extension on the [Position] class from the geolocator package.
///
/// This provides convenient mapping methods to convert geographic coordinates
/// into common format objects used for mapping and location services.
extension PositionExtension on Position {

  /// Converts the [Position] into a [LatLng] object.
  ///
  /// This is typically used for integrating with Google Maps or other
  /// mapping SDKs that require a standard latitude/longitude pair.
  LatLng get latLng => LatLng(latitude, longitude);

  /// Converts the [Position] into a custom [Location] domain model.
  ///
  /// Use this to transform raw GPS data into your application's internal
  /// location representation for business logic or storage.
  Location get location => Location(latitude: latitude, longitude: longitude);
}
