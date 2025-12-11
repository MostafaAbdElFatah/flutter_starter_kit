import 'package:flutter/material.dart';
import '../../../core/extensions/context/context_extension.dart';


/// A customizable scaffold widget that wraps Flutter's [Scaffold] with additional
/// configurations and default styling.
///
/// This widget simplifies scaffold setup by providing default behaviors
/// and allowing easy customization through its parameters.
class AppScaffold extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The primary content of the scaffold.
  final Widget? body;

  /// A panel that slides in from the side of the scaffold.
  final Widget? drawer;

  /// Determines if the body should include a safe area.
  final bool useSafeArea;

  /// An optional bottom sheet widget that appears at the bottom of the scaffold.
  final Widget? bottomSheet;

  /// A widget to display at the bottom of the scaffold, typically a [BottomNavigationBar].
  final Widget? bottomNavigationBar;

  /// A floating action button displayed above the [body].
  final Widget? floatingActionButton;

  /// The app bar displayed at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The key used to control the scaffold.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// Whether the scaffold should adjust its content when the on-screen keyboard appears.
  final bool resizeToAvoidBottomInset;

  /// Determines the location of the floating action button.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // ================================
  //        Constructor
  // ================================

  /// Creates an [AppScaffold] with the given parameters.
  ///
  /// All parameters are optional and have sensible defaults to ensure flexibility.
  const AppScaffold({
    super.key,
    this.scaffoldKey,
    this.appBar,
    this.body,
    this.drawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.useSafeArea = false,
    this.resizeToAvoidBottomInset = false, // Default to not resizing
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // Determine the background color, falling back to a theme color if not provided.
    final Color bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;

    final Widget scaffoldBody = useSafeArea ? SafeArea(child: body!) : body!;

    // Return the configured Scaffold.
    return GestureDetector(
      onTap: () => context.hideKeyboard(),
      child: Scaffold(
        extendBody: true,
        key: scaffoldKey, // Assign the scaffold key if provided.
        appBar: appBar, // Set the app bar if provided.
        drawer: drawer, // Set the drawer if provided.
        backgroundColor: bgColor, // Apply the background color.
        body: scaffoldBody, // Set the (possibly wrapped) body.
        bottomSheet: bottomSheet, // Set the bottom sheet if provided.
        bottomNavigationBar:
        bottomNavigationBar, // Set the bottom navigation bar if provided.
        floatingActionButton: floatingActionButton, // Set the FAB if provided.
        floatingActionButtonLocation:
        floatingActionButtonLocation, // Set FAB location if provided.
        resizeToAvoidBottomInset:
        resizeToAvoidBottomInset, // Control resizing behavior.
      ),
    );
  }


  // ================================
  //        Helper Methods
  // ================================


}
