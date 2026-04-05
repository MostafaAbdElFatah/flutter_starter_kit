import '../../common/dialog_guard.dart';
import '../../di/injection.dart' as di;
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
    String message, {
    OpenMode mode = OpenMode.drops,
  }) => openAdaptiveDialog(
    AdaptiveDialogOptions(
      message: message,
      imageType: AlertType.failure,
      confirmLabel: LocalizationKeys.cancel,
    ),
    mode: mode,
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
    OpenMode mode = OpenMode.drops,
  }) => di.dialogGuard.show<T>(
    mode: mode,
    open: () {
      final dialogContext = mode == OpenMode.stacks
          ? Navigator.of(this, rootNavigator: true).overlay?.context ?? this
          : this;
      return showDialog<T>(
        context: dialogContext,
        barrierDismissible: barrierDismissible,
        useRootNavigator: true,
        builder: (_) => child,
      );
    },
    closeActive: () async {
      final navigator = Navigator.of(this, rootNavigator: true);
      await navigator.maybePop();
    },
  );

  /// Displays a modal bottom sheet using the app's design conventions.
  ///
  /// This is a thin wrapper around [showModalBottomSheet] with:
  /// - Default rounded top corners
  /// - Transparent background
  /// - Configurable dismissal and scroll behavior
  ///
  /// Prefer using this method instead of calling [showModalBottomSheet]
  /// directly to maintain UI consistency across YourSaudiGuide.
  ///
  /// Returns a [Future] that completes when the sheet is dismissed,
  /// optionally returning a value of type [T].
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
  }) => showModalBottomSheet<T>(
    shape: shape,
    context: this,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}
