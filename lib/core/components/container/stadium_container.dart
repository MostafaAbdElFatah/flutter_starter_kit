import 'package:flutter/material.dart';

/// A customizable container with a stadium-shaped border.
///
/// The [StadiumContainer] is a flexible widget that allows you to create a
/// container with rounded edges (stadium shape) and offers various customization
/// options such as border, size, padding, margin, background color, and optional
/// child content.
///
/// Example usage:
/// ```dart
/// StadiumContainer(
///   background: Colors.blueAccent,
///   borderColor: Colors.white,
///   borderWidth: 2,
///   padding: EdgeInsets.all(16),
///   margin: EdgeInsets.symmetric(horizontal: 20),
///   child: Text('Stadium Container'),
/// )
/// ```
class StadiumContainer extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The width of the container.
  ///
  /// If not specified, it adapts to its child or parent constraints.
  final double? width;

  /// The height of the container.
  ///
  /// If not specified, it adapts to its child or parent constraints.
  final double? height;

  /// The child widget to be displayed inside the container.
  final Widget? child;

  /// The width of the border.
  ///
  /// Defaults to `1` if not specified and [borderColor] is provided.
  final double? borderWidth;

  /// The background color of the container.
  ///
  /// This parameter is required.
  final Color background;

  /// The color of the border.
  ///
  /// If `null`, no border will be drawn.
  final Color? borderColor;

  /// The alignment of the child within the container.
  ///
  /// Defaults to [Alignment.center].
  final AlignmentGeometry? alignment;

  /// The margin around the container.
  final EdgeInsetsGeometry? margin;

  /// The padding inside the container.
  final EdgeInsetsGeometry? padding;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [StadiumContainer].
  ///
  /// - [background] is required and sets the container's background color.
  /// - [child] defines the content inside the container.
  /// - [width] and [height] determine the container's size.
  /// - [borderColor] and [borderWidth] customize the border's appearance.
  /// - [margin] and [padding] handle spacing around and inside the container.
  /// - [alignment] defines how the child is positioned within the container.
  const StadiumContainer({
    super.key,
    required this.background,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.alignment,
    this.borderColor,
    this.borderWidth,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    return Container(
      // ================================
      //        Size Configuration
      // ================================

      /// Sets the container's width and height.
      width: width,
      height: height,

      // ================================
      //           Spacing
      // ================================

      /// Adds margin around the container.
      margin: margin,

      /// Adds padding inside the container.
      padding: padding,

      // ================================
      //         Alignment
      // ================================

      /// Aligns the child widget within the container.
      alignment: alignment,

      // ================================
      //         Decoration
      // ================================

      /// Applies decoration to the container, including background color,
      /// border, and shape.
      decoration: ShapeDecoration(
        // Sets the container's background color.
        color: background,

        // Defines the stadium-shaped border.
        shape: StadiumBorder(
          side: borderColor != null
              ? BorderSide(
                  color: borderColor!, // Uses the provided border color.
                  width: borderWidth ??
                      1, // Defaults to 1 if borderWidth is not specified.
                )
              : BorderSide.none, // No border if borderColor is null.
        ),
      ),

      // ================================
      //            Child
      // ================================

      /// The child widget placed inside the container.
      child: child,
    );
  }
}
