import '../../core.dart';

/// A lightweight, reusable app bar with optional title, actions, and padding.
class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// Explicit height of the app bar. Defaults to `56.h`.
  final double? height;

  /// Title text used when [customTitle] is not provided.
  final String? title;

  /// App bar elevation.
  final double? elevation;

  /// Whether to center the title.
  final bool? centerTitle;

  /// Optional custom widget to render as the title.
  final Widget? customTitle;

  /// Optional action widgets displayed at the end of the app bar.
  final List<Widget>? actions;

  /// Background color of the app bar.
  final Color? backgroundColor;

  /// External padding around the app bar.
  final EdgeInsetsGeometry? padding;

  /// Optional bottom widget, such as a [TabBar].
  final PreferredSizeWidget? bottom;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [BasicAppBar] with the given parameters.
  ///
  /// - [title]: Text used when [customTitle] is not provided.
  /// - [customTitle]: Custom widget to render as the title.
  /// - [actions]: Widgets displayed at the end of the app bar.
  /// - [height]: Explicit height for the app bar (defaults to `56.h`).
  /// - [padding]: External padding around the app bar.
  /// - [bottom]: Optional bottom widget, such as a [TabBar].
  /// - [elevation]: App bar elevation.
  /// - [centerTitle]: Whether to center the title.
  /// - [backgroundColor]: Background color of the app bar.
  const BasicAppBar({
    super.key,
    this.title,
    this.customTitle,
    this.actions,
    this.height,
    this.padding,
    this.bottom,
    this.elevation,
    this.centerTitle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
      child: AppBar(
        titleSpacing: 0,
        bottom: bottom,
        actions: actions,
        elevation: elevation,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.black),

        title:
            customTitle ??
            Text(title ?? '', style: AppColors.black.bold(fontSize: 16)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 56.h);
}
