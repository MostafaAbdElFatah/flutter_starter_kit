import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// A customizable container with rounded corners, optional border, and shadow.
///
/// The [RoundedContainer] allows you to create a container with rounded edges,
/// customizable background color, border, padding, margin, alignment, and shadow.
/// It is highly reusable and can adapt to various UI requirements.
class RoundedContainer extends StatelessWidget {
  /// The width of the container. If not specified, it will adapt to its child or parent constraints.
  final double? width;

  /// The height of the container. If not specified, it will adapt to its child or parent constraints.
  final double? height;

  /// The child widget to be placed inside the container.
  final Widget? child;

  /// The radius of the rounded corners. Defaults to `14`.
  final double? borderRadius;

  /// The background color of the container. This is a required parameter.
  final Color background;

  /// Whether to apply a border to the container. Defaults to `false`.
  final bool applyBorder;

  /// The border around the container. If not provided, a default border will be used.
  final BoxBorder? border;

  /// The color of the border. Defaults to `AppColors.silver`.
  final Color? borderColor;

  /// The width of the border. Defaults to `1`.
  final double? borderWidth;

  /// The margin around the container.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the container.
  final EdgeInsetsGeometry? padding;

  /// The alignment of the child within the container. Defaults to [Alignment.center].
  final AlignmentGeometry? alignment;

  /// Whether to apply a shadow to the container. Defaults to `false`.
  final bool applyShadow;

  /// The shadow effect for the container. Only applied if [applyShadow] is `true`.
  final List<BoxShadow>? boxShadow;

  /// Creates a [RoundedContainer].
  ///
  /// - [background]: The background color of the container (required).
  /// - [child]: The widget placed inside the container.
  /// - [width]: The width of the container.
  /// - [height]: The height of the container.
  /// - [borderRadius]: The radius of the rounded corners (default: `14`).
  /// - [applyBorder]: Whether to apply a border to the container (default: `false`).
  /// - [border]: The border around the container (optional).
  /// - [borderColor]: The color of the border (default: `AppColors.silver`).
  /// - [borderWidth]: The width of the border (default: `1`).
  /// - [margin]: The margin around the container.
  /// - [padding]: The padding inside the container.
  /// - [alignment]: The alignment of the child within the container (default: [Alignment.center]).
  /// - [applyShadow]: Whether to apply a shadow to the container (default: `false`).
  /// - [boxShadow]: The shadow effect for the container (optional). Only applied if [applyShadow] is `true`.
  const RoundedContainer({
    super.key,
    required this.background,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.applyBorder = false,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.margin,
    this.padding,
    this.alignment,
    this.applyShadow = false,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Sets the width of the container
      width: width,

      // Sets the height of the container
      height: height,

      // Applies margin around the container
      margin: margin,

      // Applies padding inside the container
      padding: padding,

      // Aligns the content (child) in the center by default.
      alignment: alignment,

      // Defines the decoration of the container
      decoration: BoxDecoration(
        // Sets the background color of the container
        color: background,
        // Defines the shape and border of the container
        borderRadius: BorderRadius.circular(borderRadius ?? 14),

        border: applyBorder
            ? border ??
                Border.all(
                  // Sets the border width (default: 1)
                  width: borderWidth ?? 1,
                  // Sets the border color (default: AppColors.silver)
                  color: borderColor ?? AppColors.silver,
                )
            : null,
        boxShadow: applyShadow
            ? boxShadow ??
                [
                  BoxShadow(
                    // Shadow color with opacity
                    color: Colors.grey.withValues(alpha: 0.5),
                    // Vertical offset for shadow
                    offset: const Offset(0, 3),
                    // How soft the shadow is
                    blurRadius: 7,
                    // Spread of the shadow
                    spreadRadius: 0,
                  ),
                ]
            : null,
      ),

      // Places the child widget inside the container
      child: child,
    );
  }
}
