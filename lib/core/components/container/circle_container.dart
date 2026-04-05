import 'package:auto_size_text/auto_size_text.dart';

import '../../core.dart';

class CircleContainer extends StatelessWidget {
  final double? size;
  final double? width;
  final double? height;
  final Widget? child;
  final Color? background;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const CircleContainer({
    super.key,
    this.size,
    this.width,
    this.height,
    this.child,
    this.background,
    this.borderColor,
    this.borderWidth = 1,
    this.margin,
    this.padding,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = size ?? width;
    final effectiveHeight = size ?? height;

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: background,
        shape: CircleBorder(
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(
                  color: borderColor!,
                  width: borderWidth,
                ),
        ),
      ),
      child: child,
    );
  }
}

class CircleNumContainer extends StatelessWidget {
  final int number;
  final Color? textColor;
  final Color? background;
  final Color? borderColor;
  final double borderWidth;
  final AutoSizeGroup? group;
  const CircleNumContainer({
    super.key,
    required this.number,
    this.borderWidth = 1,
    this.textColor,
    this.background,
    this.borderColor,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    return CircleContainer(
      size: 30.w,
      background: background ?? Theme.of(context).primaryColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      child: AutoSizeText(
        "$number",
        maxLines: 1,
        minFontSize: 5,
        group: group,
        style: AppColors.white.bold(fontSize: 14).copyWith(color: textColor),
      ),
    );
  }
}
