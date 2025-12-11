import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A customizable container widget that displays an SVG image as a background
/// with optional padding, margin, and child widgets.
///
/// This widget is useful for creating layouts with SVG backgrounds while
/// allowing additional content to be overlaid on top of the SVG image.
class BackgroundContainer extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The file path to the SVG asset used as the background.
  final String? svgAssetPath;

  /// The file path to the SVG asset used as the background.
  final String? imageAssetPath;

  /// How to inscribe the SVG image into the space allocated during layout.
  /// The default is [BoxFit.contain].
  final BoxFit fit;

  /// Empty space to inscribe inside the container. The [child], if any, is
  /// placed inside this padding.
  ///
  /// This padding is in addition to any padding inherent in the [decoration];
  /// see [Decoration.padding].
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the container and its contents.
  final EdgeInsetsGeometry? margin;

  /// The child widget contained within the container.
  ///
  /// If null, the container will only display the SVG image.
  final Widget? child;

  /// The decoration to paint behind the [child].
  ///
  /// Use the [color] property to specify a simple solid color.
  ///
  /// The [child] is not clipped to the decoration. To clip a child to the shape
  /// of a particular [ShapeDecoration], consider using a [ClipPath] widget.
  final Decoration? decoration;


  // ================================
  //        Constructor
  // ================================

  /// Creates an [BackgroundContainer] with the given parameters.
  ///
  /// - [svgAssetPath]: The file path to the SVG asset used as the background.
  /// - [fit]: How to inscribe the SVG image into the space allocated during layout.
  /// - [padding]: The padding inside the container.
  /// - [margin]: The margin around the container.
  /// - [child]: The child widget contained within the container.
  /// - [decoration]: The decoration to paint behind the [child].
  const BackgroundContainer({
    super.key,
    this.svgAssetPath,
    this.imageAssetPath,
    this.fit = BoxFit.contain,
    this.padding,
    this.margin,
    this.child, this.decoration,
  }) : assert(
          svgAssetPath != null || imageAssetPath != null,
          'Either svgAssetPath or imageAssetPath must be provided.',
        );

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Display the SVG image as the background, filling the available space.
        if (svgAssetPath != null)
          Positioned.fill(
            child: SvgPicture.asset(svgAssetPath!, fit: fit),
          ),

        // Display the SVG image as the background, filling the available space.
        if (imageAssetPath != null)
          Positioned.fill(
            child: Image.asset(imageAssetPath!, fit: fit),
          ),

        // Display the child widget with optional padding and margin.
        Positioned.fill(
          child: Container(
            margin: margin,
            decoration: decoration,
            alignment: Alignment.center,
            padding: padding ?? const EdgeInsets.all(10),
            child: child,
          ),
        ),
      ],
    );
  }
}
