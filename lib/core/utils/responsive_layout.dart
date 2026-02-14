import 'package:flutter/widgets.dart';

class ResponsiveScope extends InheritedWidget {
  final ResponsiveLayout layout;
  static ResponsiveLayout? _currentLayout;

  ResponsiveScope({
    super.key,
    required this.layout,
    required super.child,
  }) {
    _currentLayout = layout;
  }

  static ResponsiveLayout of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    assert(
      scope != null,
      'ResponsiveScope not found in widget tree. Wrap your app with ResponsiveScope.',
    );
    final resolvedLayout = scope?.layout;
    if (resolvedLayout == null) {
      throw FlutterError(
        'ResponsiveScope not found in widget tree. Wrap your app with ResponsiveScope.',
      );
    }
    _currentLayout = resolvedLayout;
    return resolvedLayout;
  }

  static ResponsiveLayout get current {
    final layout = _currentLayout;
    assert(
      layout != null,
      'ResponsiveScope has not been initialized. Ensure ResponsiveScope is built before using num extensions.',
    );
    if (layout == null) {
      throw FlutterError(
        'ResponsiveScope has not been initialized. Ensure ResponsiveScope is built before using num extensions.',
      );
    }
    return layout;
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
  static const Size defaultBaseSize = Size(390, 844);
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;
  static const double _mobileWidthMinScale = 0.88;
  static const double _mobileWidthMaxScale = 1.15;
  static const double _tabletWidthMaxScale = 1.95;
  static const double _mobileHeightMinScale = 0.85;
  static const double _mobileHeightMaxScale = 1.12;
  static const double _tabletHeightMaxScale = 1.35;
  static const double _mobileTextMinScale = 0.8;
  static const double _mobileTextMaxScale = 1.0;
  static const double _tabletTextMinScale = 1.05;
  static const double _tabletTextMaxScale = 1.25;

  final Size baseSize;
  final Size screenSize;

  ResponsiveLayout(BuildContext context, {Size baseSize = defaultBaseSize})
    : this.fromSize(screenSize: MediaQuery.sizeOf(context), baseSize: baseSize);

  const ResponsiveLayout.fromSize({
    required this.screenSize,
    this.baseSize = defaultBaseSize,
  });

  // Device type detection
  bool get isTablet => screenSize.shortestSide >= tabletBreakpoint;
  bool get isDesktop => screenSize.shortestSide >= desktopBreakpoint;
  bool get isMobile => screenSize.shortestSide < tabletBreakpoint;

  // Private scale factors
  double get _widthScale {
    final maxScale = isTablet ? _tabletWidthMaxScale : _mobileWidthMaxScale;
    final ratio = screenSize.width / baseSize.width;
    return ratio.clamp(_mobileWidthMinScale, maxScale);
  }

  double get _heightScale {
    final maxScale = isTablet ? _tabletHeightMaxScale : _mobileHeightMaxScale;
    final ratio = screenSize.height / baseSize.height;
    return ratio.clamp(_mobileHeightMinScale, maxScale);
  }

  double get _textScale {
    if (isTablet) {
      final ratio = screenSize.shortestSide / tabletBreakpoint;
      return ratio.clamp(_tabletTextMinScale, _tabletTextMaxScale);
    }
    final ratio = screenSize.width / baseSize.width;
    return ratio.clamp(_mobileTextMinScale, _mobileTextMaxScale);
  }

  // Core scaling methods

  /// Scales a width value based on screen width
  double width(double value) => value * _widthScale;

  /// Scales a height value based on screen height
  double height(double value) => value * _heightScale;

  /// Scales a font size value
  double fontSize(double value) => value * _textScale;

  // Convenience aliases
  double w(double value) => width(value);
  double h(double value) => height(value);
  double sp(double value) => fontSize(value);

  // Padding helpers

  /// Creates uniform padding scaled to screen width
  EdgeInsets padding(double value) => EdgeInsets.all(width(value));

  /// Creates horizontal padding scaled to screen width
  EdgeInsets paddingHorizontal(double value) =>
      EdgeInsets.symmetric(horizontal: width(value));

  /// Creates vertical padding scaled to screen height
  EdgeInsets paddingVertical(double value) =>
      EdgeInsets.symmetric(vertical: height(value));

  /// Creates symmetric padding with separate horizontal and vertical values
  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(
        horizontal: width(horizontal),
        vertical: height(vertical),
      );

  // Spacing helpers

  /// Creates a horizontal spacing box
  SizedBox spacingWidth(double value) => SizedBox(width: width(value));

  /// Creates a vertical spacing box
  SizedBox spacingHeight(double value) => SizedBox(height: height(value));

  // Aliases for spacing
  SizedBox get space4 => spacingHeight(4);
  SizedBox get space8 => spacingHeight(8);
  SizedBox get space12 => spacingHeight(12);
  SizedBox get space16 => spacingHeight(16);
  SizedBox get space24 => spacingHeight(24);
  SizedBox get space32 => spacingHeight(32);
}

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

  double get w => _layout.width(toDouble());
  double get h => _layout.height(toDouble());
  double get sp => _layout.fontSize(toDouble());

  EdgeInsets get padding => _layout.padding(toDouble());
  EdgeInsets get paddingVertical => _layout.paddingVertical(toDouble());
  EdgeInsets get paddingHorizontal => _layout.paddingHorizontal(toDouble());

  SizedBox get spacingWidth => _layout.spacingWidth(toDouble());
  SizedBox get spacingHeight => _layout.spacingHeight(toDouble());
}
