import 'package:auto_size_text/auto_size_text.dart';


import '../../core.dart';

/// Position of the icon relative to the text.
enum ButtonIconPosition { leading, trailing }

/// An elevated button with an icon and optional subtitle.
class IconTextElevatedButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Primary label text.
  final String title;

  /// Optional subtitle shown below the title.
  final String? subTitle;

  // Icon sources

  /// Material icon to display.
  final IconData? icon;

  /// SVG asset path to display.
  final String? svgIcon;

  /// Image asset path to display.
  final String? assetImage;

  /// Optional title color override.
  final Color? iconColor;

  /// Icon placement relative to the text.
  final ButtonIconPosition iconPosition;

  /// Icon size override.
  final double? iconSize;

  /// Optional title color override.
  final Color? titleColor;

  /// Optional title style override.
  final TextStyle? titleStyle;

  /// Synchronizes the size of multiple [AutoSizeText]s.
  final AutoSizeGroup? group;

  /// Optional subtitle style override.
  final TextStyle? subTitleStyle;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional button style override.
  final ButtonStyle? buttonStyle;

  /// Tap callback for the button.
  final VoidCallback? onPressed;

  /// Optional padding around the button child.
  final EdgeInsetsGeometry? padding;

  // ================================
  //        Constructor
  // ================================

  /// Creates an [IconTextElevatedButton] with the given parameters.
  const IconTextElevatedButton({
    super.key,
    required this.title,
    this.subTitle,
    this.icon,
    this.svgIcon,
    this.assetImage,
    this.iconColor,
    this.iconPosition = ButtonIconPosition.leading,
    this.iconSize,
    this.titleColor,
    this.titleStyle,
    this.subTitleStyle,
    this.backgroundColor,
    this.buttonStyle,
    this.onPressed,
    this.padding,
    this.group,
  }) : assert(
         icon != null || svgIcon != null || assetImage != null,
         'You must provide icon, svgIcon, or assetImage',
       );

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    final iconWidget = _buildIcon(context, isEnabled);

    return ElevatedButton(
      onPressed: onPressed,
      style:
          buttonStyle ??
          Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: backgroundColor != null && isEnabled
                ? WidgetStateProperty.all(backgroundColor!)
                : null,
          ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPosition == ButtonIconPosition.leading) ...[
              iconWidget,
              SizedBox(width: 6.w),
            ],
            _buildText(context, isEnabled),
            if (iconPosition == ButtonIconPosition.trailing) ...[
              SizedBox(width: 6.w),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, bool isEnabled) {
    final baseColor = isEnabled
        ? (titleColor ?? AppColors.white)
        : Theme.of(context).disabledColor;

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            title,
            maxLines: 1,
            group: group,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ?? baseColor.bold(fontSize: 16),
          ),
          if (subTitle != null) ...[
            SizedBox(height: 2.h),
            AutoSizeText(
              subTitle!,
              maxLines: 1,
              group: group,
              overflow: TextOverflow.ellipsis,
              style: subTitleStyle ?? baseColor.regular(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, bool isEnabled) {
    final size = iconSize ?? 28.w;

    if (svgIcon != null) {
      return SvgIcon(
        size: size,
        color: iconColor,
        isEnabled: isEnabled,
        svgAssetPath: svgIcon!,
      );
    }

    if (assetImage != null) {
      return Image.asset(
        assetImage!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        color: isEnabled ? iconColor : Theme.of(context).disabledColor,
      );
    }

    return Icon(
      icon!,
      size: size,
      color: isEnabled
          ? iconColor ?? titleColor ?? AppColors.white
          : Theme.of(context).disabledColor,
    );
  }
}
