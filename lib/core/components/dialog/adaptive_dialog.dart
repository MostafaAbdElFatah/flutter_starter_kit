import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core.dart';

/// Configuration options for [AdaptiveDialog].
class AdaptiveDialogOptions {
  /// Optional dialog title.
  final String? title;

  /// Optional dialog message.
  final String? message;

  /// Optional dialog custom content.
  final Widget? content;

  /// Image alert type used for image confirmation dialogs.
  final AlertType? imageType;

  /// Optional SVG asset path for a custom icon.
  final String? svgAssetPath;

  /// Optional image asset path for a custom image.
  final String? imageAssetPath;

  /// Optional [IconData] for a custom icon.
  final IconData? icon;

  /// Optional icon/image width.
  final double? imageWidth;

  /// Optional icon/image height.
  final double? imageHeight;

  /// Optional title color.
  final Color? titleColor;

  /// Optional message/subtitle color.
  final Color? messageColor;

  /// The label for the confirm button.
  final String? confirmLabel;

  /// The label for the cancel button.
  final String? cancelLabel;

  /// Optional confirm button background color.
  final Color? confirmBackground;

  /// Optional cancel button background color.
  final Color? cancelBackground;

  /// Optional confirm button style override.
  final ButtonStyle? confirmButtonStyle;

  /// Optional cancel button style override.
  final ButtonStyle? cancelButtonStyle;

  /// Callback triggered when the confirm button is pressed.
  final VoidCallback? onConfirmPressed;

  /// Callback triggered when the cancel button is pressed.
  final VoidCallback? onCancelPressed;

  /// Creates an [AdaptiveDialogOptions].
  ///
  /// - [title]: Optional title for the dialog.
  /// - [message]: Optional message for the dialog.
  /// - [content]: Optional custom content widget for the dialog.
  /// - [titleColor]: Optional title color.
  /// - [messageColor]: Optional message/subtitle color.
  /// - [confirmLabel]: Text for the confirm button.
  /// - [cancelLabel]: Text for the cancel button.
  /// - [confirmBackground]: Background color for the confirm button.
  /// - [cancelBackground]: Background color for the cancel button.
  /// - [confirmButtonStyle]: Custom style for the confirm button.
  /// - [cancelButtonStyle]: Custom style for the cancel button.
  /// - [svgAssetPath]: Custom SVG asset path.
  /// - [imageAssetPath]: Custom image asset path.
  /// - [icon]: Custom [IconData] for an icon.
  /// - [imageWidth]: Custom icon/image width.
  /// - [onConfirmPressed]: Optional confirm press callback.
  /// - [onCancelPressed]: Optional cancel press callback.
  const AdaptiveDialogOptions({
    this.title,
    this.message,
    this.content,
    this.titleColor,
    this.messageColor,
    this.confirmLabel,
    this.cancelLabel,
    this.imageType,
    this.svgAssetPath,
    this.imageAssetPath,
    this.icon,
    this.imageWidth,
    this.imageHeight,
    this.confirmBackground,
    this.cancelBackground,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    this.onConfirmPressed,
    this.onCancelPressed,
  });
}

/// A unified dialog that can render message, confirmation, or image confirmation.
///
/// When [variant] is not provided, the dialog is inferred as follows:
/// - If [imageType] is set => [AppDialogVariant.imageConfirmation]
/// - Else if [onCancelPressed] or [options.cancelLabel] is set => [AppDialogVariant.confirmation]
/// - Else => [AppDialogVariant.message]
class AdaptiveDialog extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Visual and button configuration.
  final AdaptiveDialogOptions options;

  // ================================
  //        Constructor
  // ================================

  /// Creates an [AdaptiveDialog] with optional overrides.
  const AdaptiveDialog({
    super.key,
    this.options = const AdaptiveDialogOptions(),
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: LiquidGlassContainer(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              if (options.icon != null ||
                  options.svgAssetPath != null ||
                  options.imageAssetPath != null ||
                  options.imageType != null) ...[
                _buildIcon(),
                SizedBox(height: 10.h),
              ],
              if (options.title != null) ...[
                Text(
                  options.title!,
                  textAlign: TextAlign.center,
                  style: AppColors.white
                      .bold(fontSize: 18)
                      .copyWith(color: options.titleColor),
                ),
                SizedBox(height: 20.h),
              ],
              if (options.message != null) ...[
                Text(
                  options.message!,
                  textAlign: TextAlign.center,
                  style: AppColors.white
                      .regular(fontSize: 14)
                      .copyWith(color: options.messageColor),
                ),
                SizedBox(height: 20.h),
              ],
              if (options.content != null) ...[
                options.content!,
                SizedBox(height: 20.h),
              ],
              if (options.onCancelPressed != null &&
                  options.onCancelPressed != null)
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildConfirmButton(context)),
                    SizedBox(width: 10.w),
                    Expanded(flex: 2, child: _buildCancelButton(context)),
                  ],
                )
              else
                Center(
                  child: FlexibleElevatedButton(
                    label: options.confirmLabel ?? LocalizationKeys.ok,
                    onPressed: options.onConfirmPressed ?? () => context.pop(),
                    padding: EdgeInsets.zero,
                    textColor: AppColors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================
  //            Helpers
  // ================================

  Widget _buildIcon() {
    final double width = options.imageWidth ?? 80.w;
    final double height = options.imageHeight ?? 80.w;

    if (options.svgAssetPath != null) {
      return SvgPicture.asset(
        options.svgAssetPath!,
        width: width,
        height: height,
      );
    }

    if (options.icon != null) {
      final double size = options.imageWidth ?? options.imageHeight ?? 80.w;
      return Icon(options.icon, size: size, color: AppColors.white);
    }

    return SvgPicture.asset(
      options.imageAssetPath ?? options.imageType!.assetPath,
      width: width,
      height: height,
    );
  }

  Widget _buildConfirmButton(BuildContext context) => FlexibleElevatedButton(
    padding: EdgeInsets.zero,
    onPressed: options.onConfirmPressed ?? () => Navigator.of(context).pop(),
    label: options.confirmLabel ?? LocalizationKeys.ok,
    backgroundColor: options.confirmBackground,
    buttonStyle: options.confirmButtonStyle,
    textStyle: AppColors.white.bold(fontSize: 14),
  );

  Widget _buildCancelButton(BuildContext context) => FlexibleElevatedButton(
    padding: EdgeInsets.zero,
    label: options.cancelLabel ?? LocalizationKeys.cancel,
    onPressed: options.onCancelPressed ?? () => Navigator.of(context).pop(),
    backgroundColor: options.cancelBackground,
    buttonStyle: options.cancelButtonStyle,
    textStyle: AppColors.white.bold(fontSize: 14),
  );
}

/// Defines the visual intent and associated imagery for alert dialogs.
enum AlertType {
  /// Indicates a successful operation (e.g., data saved).
  success,

  /// Indicates a failed operation or server error.
  failure,

  /// Represents a non-critical warning that requires attention.
  warning,

  /// Represents a critical warning or a destructive action.
  critical,
}

/// Helper extension to map [ImageAlertType] to its corresponding SVG asset.
extension AlertTypeX on AlertType {
  /// Returns the SVG asset path associated with the current alert type.
  /// Returns the asset path based on the type
  String get assetPath {
    return switch (this) {
      AlertType.success => SvgIcons.success,
      AlertType.failure => SvgIcons.shieldFail,
      AlertType.warning => SvgIcons.warning,
      AlertType.critical => SvgIcons.critical,
    };
  }
}

/// Extension methods for [BuildContext] to simplify showing design-system dialogs.
extension DialogX on BuildContext {
  /// Displays a customized dialog based on the app's design system.
  ///
  /// This is the base method used by other dialog helpers in this extension.
  Future<T?> openAdaptiveDialog<T>(
    AdaptiveDialogOptions options, {
    bool barrierDismissible = true,
  }) => openDialog<T>(
    barrierDismissible: barrierDismissible,
    child: AdaptiveDialog(options: options),
  );
}
