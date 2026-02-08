import '../../core.dart';

/// Extension methods for [BuildContext] to streamline navigation and design-system dialogs.
extension BuildContextx on BuildContext {
  /// Closes the current screen or dialog and removes it from the navigation stack.
  ///
  /// Optionally accepts a [result] to pass back to the previous route.
  // void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  /// Displays a modal dialog specifically styled for failure or error states.
  ///
  /// This convenience method wraps [openAdaptiveDialog] with a pre-configured
  /// [AlertType.failure] icon and a default cancel label.
  ///
  /// Returns a [Future] that completes when the user acknowledges the error.
  Future<T?> openFailureDialog<T>(
      String message,
      ) =>
      openAdaptiveDialog(
        AdaptiveDialogOptions(
          message: message,
          imageType: AlertType.failure,
          confirmLabel: LocalizationKeys.cancel,
        ),
      );

  /// Displays a customized modal dialog using the app's design system.
  ///
  /// This serves as the primary internal wrapper for [showDialog], ensuring
  /// the correct [BuildContext] is utilized.
  ///
  /// Returns a [Future] that completes when the dialog is dismissed,
  /// potentially carrying a return value of type [T].
  Future<T?> openDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) =>
      showDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: (_) => child,
      );

  Future<T?> openModalBottomSheet<T>({
    bool isDismissible = true,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    ShapeBorder? shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    required Widget child,
  }) =>
      showModalBottomSheet<T>(
        shape: shape,
        context: this,
        isDismissible: isDismissible,
        useRootNavigator: useRootNavigator,
        isScrollControlled: isScrollControlled,
        backgroundColor: Colors.transparent,
        builder: (_) => child,
      );
}
