import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:url_launcher/url_launcher.dart';

/// Extension methods for [BuildContext]
/// Provides helpers for:
/// - Screen sizing
/// - Device type detection
/// - Keyboard control
/// - Opening web pages and map apps
extension ContextExtension on BuildContext {
  /// Default design size based on device type
  /// Tablet → 1200 x 1920
  /// Phone  → 432 x 932
  Size get defaultSize =>
      isTablet ? const Size(1200, 1920) : const Size(432, 932);

  /// Opens a web page inside an in-app browser
  Future<void> openWebPage(String url) {
    return FlutterWebBrowser.openWebPage(url: url);
  }

  /// Returns `true` if the device is considered a tablet
  /// based on aspect ratio and shortest side
  bool get isTablet {
    final mediaQuery = MediaQuery.of(this);
    final aspectRatio = mediaQuery.size.aspectRatio;

    return aspectRatio < 1.6 && mediaQuery.size.shortestSide >= 600;
  }

  /// Hides the soft keyboard if it is currently open
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
