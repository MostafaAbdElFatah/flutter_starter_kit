import '../../core.dart';

class BorderedContainer extends StatelessWidget {
  final Color? color;
  final Widget child;
  final Color? borderColor;
  final double borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const BorderedContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(10.w),
      padding: padding ?? EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius ?? 10.w),
        border: Border.all(
          color: borderColor ?? AppColors.white,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}
