import 'package:flutter/widgets.dart';

class ResponsiveScope extends InheritedWidget {
  final ResponsiveLayout layout;

  const ResponsiveScope({
    super.key,
    required this.layout,
    required super.child,
  });

  static ResponsiveLayout of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();
    assert(scope != null, 'ResponsiveScope not found in widget tree');
    return scope!.layout;
  }

  @override
  bool updateShouldNotify(covariant ResponsiveScope oldWidget) {
    return oldWidget.layout._screenSize != layout._screenSize;
  }
}

/// Handles responsive scaling for layouts across different screen sizes.
///
/// Base dimensions: 390x844 (iPhone 12 Pro dimensions)
/// Breakpoints: Tablet (600dp), Desktop (900dp)
class ResponsiveLayout {
  final Size _baseSize;
  final Size _screenSize;
  static const double _tabletBreakpoint = 600;
  static const double _desktopBreakpoint = 900;
  ResponsiveLayout(BuildContext context, {Size baseSize = const Size(390, 844)})
    : _baseSize = baseSize,
      _screenSize = MediaQuery.sizeOf(context);

  // Device type detection
  bool get isTablet => _screenSize.shortestSide >= _tabletBreakpoint;
  bool get isDesktop => _screenSize.shortestSide >= _desktopBreakpoint;
  bool get isMobile => !isTablet && !isDesktop;
  // Private scale factors
  double get _widthScale {
    final maxScale = isTablet ? 1.95 : 1.15;
    return (_screenSize.width / _baseSize.width).clamp(0.88, maxScale);
  }

  double get _heightScale {
    final maxScale = isTablet ? 1.35 : 1.12;
    return (_screenSize.height / _baseSize.height).clamp(0.85, maxScale);
  }

  double get _textScale {
    if (isTablet) {
      return (_screenSize.shortestSide / _tabletBreakpoint).clamp(1.05, 1.25);
    }
    return (_screenSize.width / _baseSize.width).clamp(0.8, 1.0);
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

  bool get isMobile => ResponsiveScope.of(this).isMobile;
  bool get isTablet => ResponsiveScope.of(this).isTablet;
  bool get isDesktop => ResponsiveScope.of(this).isDesktop;
}


extension ResponsiveNum on num {
  double get w => ResponsiveScope.of(_context).width(toDouble());
  double get h => ResponsiveScope.of(_context).height(toDouble());
  double get sp => ResponsiveScope.of(_context).fontSize(toDouble());

  EdgeInsets get padding => ResponsiveScope.of(_context).padding(toDouble());
  EdgeInsets get paddingVertical =>
      ResponsiveScope.of(_context).paddingVertical(toDouble());
  EdgeInsets get paddingHorizontal =>
      ResponsiveScope.of(_context).paddingHorizontal(toDouble());

  SizedBox get spacingWidth =>
      ResponsiveScope.of(_context).spacingWidth(toDouble());
  SizedBox get spacingHeight =>
      ResponsiveScope.of(_context).spacingHeight(toDouble());

  /// Internal context resolver
  BuildContext get _context {
    final ctx = WidgetsBinding.instance.focusManager.primaryFocus?.context;
    assert(ctx != null, 'No BuildContext available for responsive scaling');
    return ctx!;
  }
}