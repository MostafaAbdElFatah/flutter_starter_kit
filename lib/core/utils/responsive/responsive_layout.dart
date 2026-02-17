import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'device.dart';

class ResponsiveScope extends InheritedWidget {
  final ResponsiveLayout layout;
  static ResponsiveLayout? _current;
  ResponsiveScope({
    super.key,
    required BuildContext context,
    required super.child,
  }) : layout = ResponsiveLayout(context: context) {
    _current = layout;
  }

  static ResponsiveLayout get current {
    _current ??= ResponsiveLayout();
    return _current!;
  }

  static ResponsiveLayout of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();

    if (scope == null) {
      throw FlutterError(
        'ResponsiveScope not found.\n'
            'Wrap your app with ResponsiveScope.',
      );
    }
    _current = scope.layout;
    return scope.layout;
  }

  @override
  bool updateShouldNotify(covariant ResponsiveScope oldWidget) {
    return oldWidget.layout.screenSize != layout.screenSize ||
        oldWidget.layout.baseSize != layout.baseSize;
  }
}

/// Handles responsive scaling for layouts across different screen sizes.
///
/// Base dimensions: 390x844 (iPhone 12 Pro dimensions)
/// Breakpoints: Tablet (600dp), Desktop (900dp)
class ResponsiveLayout {
  final Size baseSize;
  final Size screenSize;
  final Device device;

  final double _widthScale;
  final double _heightScale;
  final double _textScale;
  static const Size _defaultBaseSize = Size(390, 844);

  // Private constructor
  const ResponsiveLayout._({
    required this.screenSize,
    required this.baseSize,
    required this.device,
    required double widthScale,
    required double heightScale,
    required double textScale,
  })  : _widthScale = widthScale,
        _heightScale = heightScale,
        _textScale = textScale;

  // Factory constructor
  factory ResponsiveLayout({
    BuildContext? context,
    Size baseSize = _defaultBaseSize,
  }) {
    final screen =
    context != null ? MediaQuery.sizeOf(context) : _logicalScreenSize();
    final device = Device.fromWidth(screen.shortestSide);
    return ResponsiveLayout._(
      screenSize: screen,
      baseSize: baseSize,
      device: device,
      widthScale: _calcWidthScale(screen, baseSize, device),
      heightScale: _calcHeightScale(screen, baseSize, device),
      textScale: _calcTextScale(screen, baseSize, device),
    );
  }

  // ---- API ----

  bool get isMobile => device.isMobile;
  bool get isMiniTablet => device.isMiniTablet;
  bool get isTablet => device.isTablet;
  bool get isDesktop => device.isDesktop;
  bool get isWeb => device.isWeb;

  double w(double v) => v * _widthScale;
  double h(double v) => v * _heightScale;
  double sp(double v) => v * _textScale;

  // Padding helpers
  // Creates uniform padding scaled to screen width
  EdgeInsets padding(double value) => EdgeInsets.all(w(value));

  /// Creates horizontal padding scaled to screen width
  EdgeInsets paddingHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: w(value));

  /// Creates vertical padding scaled to screen height
  EdgeInsets paddingVertical(double value) =>
      EdgeInsets.symmetric(vertical: h(value));

  /// Creates symmetric padding with separate horizontal and vertical values E
  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: w(horizontal), vertical: h(vertical));

  // Spacing helpers
  /// Creates a horizontal spacing box
  SizedBox spacingWidth(double value) => SizedBox(width: w(value));

  /// Creates a vertical spacing box
  SizedBox spacingHeight(double value) => SizedBox(height: h(value));

  // ---- helpers ----

  // | Device         | Width Scale | Height Scale | Text Scale  |
  // | -------------- | ----------- | ------------ | ----------- |
  // | Mobile         | 0.80 – 1.15 | 0.85 – 1.12  | 0.85 – 1.0  |
  // | Mini Tablet    | 0.85 – 1.5  | 0.9 – 1.25   | 1.05 – 1.25 |
  // | Tablet (Large) | 0.95 – 1.95 | 1.0 – 1.35   | 1.15 – 1.35 |
  // | Desktop        | 1.0 – 2.0   | 1.0 – 1.2    | 1.2 – 1.45  |
  // | Web            | 1.0 – 2.0   | 1.0 – 1.2    | 1.2 – 1.45  |

  static double _calcWidthScale(Size screen, Size base, Device device) {
    final ratio = screen.width / base.width;

    return switch (device) {
      Device.mobile => ratio.clamp(0.80, 1.15),
      Device.miniTablet => ratio.clamp(0.85, 1.5),
      Device.largeTablet => ratio.clamp(0.95, 1.95),
      Device.desktop || Device.web => ratio.clamp(1, 2.0),
    };
  }

  static double _calcHeightScale(Size screen, Size base, Device device) {
    final ratio = screen.height / base.height;

    return switch (device) {
      Device.mobile => ratio.clamp(0.85, 1.12),
      Device.miniTablet => ratio.clamp(0.9, 1.25),
      Device.largeTablet => ratio.clamp(1, 1.35),
      Device.desktop || Device.web => ratio.clamp(1, 1.2),
    };
  }

  static double _calcTextScale(Size screen, Size base, Device device) {
    final ratio = screen.shortestSide / base.shortestSide;

    return switch (device) {
      Device.mobile => ratio.clamp(0.85, 1.0),
      Device.miniTablet => ratio.clamp(1.05, 1.25),
      Device.largeTablet => ratio.clamp(1.15, 1.35),
      Device.desktop || Device.web => ratio.clamp(1.2, 1.45),
    };
  }

  static Size _logicalScreenSize() {
    final view = PlatformDispatcher.instance.views.first;
    return view.physicalSize / view.devicePixelRatio;
  }
}

// static double _calcTextScale(Size screen, Size base) {
// if (screen.shortestSide >= _tabletBreakpoint) {
// final ratio = screen.shortestSide / _tabletBreakpoint;
// return ratio.clamp(_tabletTextMinScale, _tabletTextMaxScale);
// }
// final ratio = screen.width / base.width;
// return ratio.clamp(_mobileTextMinScale, _mobileTextMaxScale);
// }
/// Extension for convenient access to ResponsiveLayout from BuildContext
extension ResponsiveLayoutExtension on BuildContext {
  /// Access responsive layout utilities
  ///
  /// Example:
  /// ```dart
  /// Text(
  ///   'Hello',
  ///   style: TextStyle(fontSize: context.responsive.sp(16)),
  /// )
  /// ```
  ResponsiveLayout get responsive => ResponsiveScope.of(this);

  /// Shorter alias for responsive
  ResponsiveLayout get r => responsive;

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
}

extension ResponsiveNum on num {
  ResponsiveLayout get _layout => ResponsiveScope.current;

  double get w => _layout.w(toDouble());
  double get h => _layout.h(toDouble());
  double get sp => _layout.sp(toDouble());

  SizedBox get spacingWidth => _layout.spacingWidth(toDouble());
  SizedBox get spacingHeight => _layout.spacingHeight(toDouble());

  EdgeInsets get padding => _layout.padding(toDouble());
  EdgeInsets get paddingVertical => _layout.paddingVertical(toDouble());
  EdgeInsets get paddingHorizontal => _layout.paddingHorizontal(toDouble());
}
