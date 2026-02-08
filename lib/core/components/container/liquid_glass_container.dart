import 'dart:ui';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../extensions/text_styles/color_text_style_extensions.dart';

class LabelLiquidGlassContainer extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final Gradient? gradient;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  const LabelLiquidGlassContainer({
    super.key,
    required this.label,
    this.style,
    this.gradient,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlassContainer(
      gradient: gradient,
      borderColor: borderColor,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: style ?? AppColors.white.regular(fontSize: 12),
      ),
    );
  }
}

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color color;
  final double opacity;
  final Gradient? gradient;
  final double borderWidth;
  final Color? borderColor;
  final double borderRadius;
  final DecorationImage? image;
  final EdgeInsetsGeometry? padding;
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.color = Colors.white,
    this.padding,
    this.borderWidth = 1,
    this.borderRadius = 20,
    this.borderColor,
    this.gradient,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            image: image,
            borderRadius: BorderRadiusDirectional.only(
              // topStart: Radius.circular(borderRadius / 2)n,
              // bottomEnd: Radius.circular(borderRadius / 2),
              topEnd: Radius.circular(borderRadius),
              bottomStart: Radius.circular(borderRadius),
            ),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.3),
              width: borderWidth,
            ),
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.1, 0.5, 1],
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.05),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
