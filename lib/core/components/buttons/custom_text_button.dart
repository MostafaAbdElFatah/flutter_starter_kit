

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core.dart';

/// A text-only button that can show a loading indicator.
class CustomTextButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Text displayed inside the button.
  final String title;

  /// Maximum number of lines for the title.
  final int? maxLines;

  /// Whether to show a loading indicator instead of the button.
  final bool isLoading;

  /// Optional text color override.
  final Color? titleColor;

  /// Optional text style override.
  final TextStyle? textStyle;

  /// Optional text decoration (underline, etc.).
  final TextDecoration? decoration;

  /// Optional padding around the text.
  final EdgeInsetsGeometry? padding;

  /// Optional button style override.
  final ButtonStyle? buttonStyle;

  /// Tap callback for the button.
  final VoidCallback? onPressed;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [CustomTextButton] with the given parameters.
  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.title,
    this.textStyle,
    this.buttonStyle,
    this.padding,
    this.titleColor,
    this.maxLines,
    this.isLoading = false,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CustomLoadingIndicator(
              colors: [Theme.of(context).primaryColor],
            ),
          )
        : TextButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(vertical: 15.w, horizontal: 5.w),
              child: Text(
                title,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: textStyle ??
                    AppColors.white.medium(fontSize: 12).copyWith(
                          color: titleColor,
                          decoration: decoration,
                          decorationColor: titleColor ?? AppColors.white,
                        ),
              ),
            ),
          );
  }
}

/// A tappable row with an optional leading icon and text label.
class CustomIconTextButton extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Text displayed beside the icon.
  final String title;

  /// Maximum number of lines for the title.
  final int? maxLines;

  /// Optional Material icon.
  final IconData? icon;

  /// Optional SVG icon asset path.
  final String? svgIcon;

  /// Icon size.
  final double? size;

  /// Optional text color override.
  final Color? titleColor;

  /// Optional text style override.
  final TextStyle? textStyle;

  /// Optional text decoration (underline, etc.).
  final TextDecoration? decoration;

  /// Optional padding around the row.
  final EdgeInsetsGeometry? padding;

  /// Tap callback for the row.
  final VoidCallback? onPressed;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [CustomIconTextButton] with the given parameters.
  const CustomIconTextButton({
    super.key,
    this.onPressed,
    required this.title,
    this.textStyle,
    this.padding,
    this.titleColor,
    this.maxLines,
    this.decoration,
    this.icon,
    this.svgIcon,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgIcon != null) ...[
              SvgIcon(
                size: size ?? 30.w,
                svgAssetPath: svgIcon!,
              ),
              SizedBox(width: 5.h)
            ],
            if (icon != null) ...[
              Icon(
                icon!,
                color: titleColor,
                size: size ?? 30.w,
              ),
              SizedBox(width: 5.h)
            ],
            Text(
              title,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: textStyle ??
                  AppColors.white.medium(fontSize: 14).copyWith(
                        color: titleColor,
                        decoration: decoration,
                        decorationColor:
                            titleColor ?? Theme.of(context).primaryColor,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
