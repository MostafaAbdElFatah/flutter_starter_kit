import 'package:flutter/material.dart';

import '../../extensions/context/context_extension.dart';


/// A scaffold with configurable background visuals and optional keyboard dismiss.
///
/// values using [backgroundImage], [gradient], or [logoWatermark].
class BackgroundScaffold extends StatelessWidget {
  /// Whether to use the variant defaults when no overrides are provided.
  final bool useDefaultBackground;

  /// Optional background image to use instead of the default.
  ///
  /// If [logoWatermark] is provided, it takes precedence over this.
  final DecorationImage? backgroundImage;

  /// Optional gradient to use instead of the default.
  final Gradient? gradient;

  /// Optional logo watermark image (used by the branded preset).
  ///
  /// When set, it replaces [backgroundImage] as the decoration image.
  final DecorationImage? logoWatermark;

  /// The primary content of the scaffold.
  final Widget? body;

  /// Whether to wrap the body in a top-only [SafeArea].
  final bool topSafeArea;

  /// Optional widget displayed as a bottom sheet.
  final Widget? bottomSheet;

  /// Background color of the scaffold (defaults to transparent).
  final Color? backgroundColor;

  /// App bar displayed at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// Widget displayed at the bottom, typically a navigation bar.
  final Widget? bottomNavigationBar;

  /// Floating action button displayed above the body.
  final Widget? floatingActionButton;

  /// Whether the scaffold should resize when the keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [BackgroundScaffold] with a background preset and optional overrides.
  ///
  /// - [variant]: Which preset background to use.
  /// - [useDefaultBackground]: Whether to use defaults for the chosen variant.
  /// - [backgroundImage]: Optional background image override.
  /// - [gradient]: Optional gradient override.
  /// - [logoWatermark]: Optional logo watermark override.
  /// - [body]: The main content of the screen.
  /// - [topSafeArea]: Wraps the body with a top-only [SafeArea] when true.
  /// - [bottomSheet]: Optional widget shown as a bottom sheet.
  /// - [backgroundColor]: Scaffold background color (default transparent).
  /// - [appBar]: Optional app bar at the top of the screen.
  /// - [bottomNavigationBar]: Optional bottom navigation widget.
  /// - [floatingActionButton]: Optional floating action button.
  /// - [floatingActionButtonLocation]: FAB location override.
  /// - [resizeToAvoidBottomInset]: Controls keyboard resize behavior.
  const BackgroundScaffold({
    super.key,
    this.useDefaultBackground = true,
    this.backgroundImage,
    this.gradient,
    this.logoWatermark,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.topSafeArea = false,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: backgroundColor,
      gradient: gradient,
      image: logoWatermark ?? backgroundImage,
    );

    return _ScaffoldShell(
      onTap: () => context.hideKeyboard(),
      decoration: decoration,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? Colors.transparent,
      body: _wrapBody(body),
      bottomSheet: bottomSheet,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _wrapBody(Widget? child) {
    final content = child ?? const SizedBox.shrink();
    return topSafeArea
        ? SafeArea(top: true, bottom: false, child: content)
        : content;
  }
}

/// Shared scaffold shell used by [CustomScaffold].
class _ScaffoldShell extends StatelessWidget {
  /// Optional tap handler used to dismiss the keyboard.
  final VoidCallback? onTap;

  /// Background decoration applied to the full screen container.
  final Decoration decoration;

  /// App bar displayed at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// Whether the scaffold should resize when the keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Background color of the scaffold.
  final Color? backgroundColor;

  /// Body widget rendered inside the scaffold.
  final Widget body;

  /// Optional widget displayed as a bottom sheet.
  final Widget? bottomSheet;

  /// Floating action button displayed above the body.
  final Widget? floatingActionButton;

  /// Location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Widget displayed at the bottom, typically a navigation bar.
  final Widget? bottomNavigationBar;

  const _ScaffoldShell({
    required this.onTap,
    required this.decoration,
    required this.appBar,
    required this.resizeToAvoidBottomInset,
    required this.backgroundColor,
    required this.body,
    required this.bottomSheet,
    required this.floatingActionButton,
    required this.floatingActionButtonLocation,
    required this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        child: Scaffold(
          appBar: appBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
          backgroundColor: backgroundColor ?? Colors.transparent,
          body: body,
          bottomSheet: bottomSheet,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}

