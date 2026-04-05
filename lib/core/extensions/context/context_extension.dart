import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Extension methods for [BuildContext]
/// Provides helpers for:
/// - Screen sizing
/// - Device type detection
/// - Keyboard control
/// - Opening web pages and map apps
extension ContextExtension on BuildContext {
  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  /// Opens the given latitude & longitude in a map application
  ///
  /// Priority:
  /// 1. Google Maps (web / app)
  /// 2. Apple Maps (iOS fallback)
  Future<void> openMap({
    required double latitude,
    required double longitude,
  }) async {
    final googleMapsWebUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    final googleMapsAppUrl = Uri.parse(
      'comgooglemaps://?daddr=$latitude,$longitude&directionsmode=driving',
    );

    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?q=$latitude,$longitude',
    );

    // Try Google Maps app
    if (await canLaunchUrl(googleMapsAppUrl)) {
      await launchUrl(googleMapsAppUrl);
      return;
    }

    // Fallback to Apple Maps
    if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    }

    // Try Google Maps (web)
    if (await canLaunchUrl(googleMapsWebUrl)) {
      await launchUrl(googleMapsWebUrl);
      return;
    }
  }
}
