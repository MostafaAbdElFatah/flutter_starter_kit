import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../constants/app_colors.dart';

/// A custom loading indicator widget that displays an orbit-style loading animation.
class OrbitLoadingView extends StatelessWidget {
  // Optional size of the loading indicator
  final double? size;
  // Optional list of colors for the loading animation
  final List<Color>? colors;

  const OrbitLoadingView({super.key, this.size, this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomLoadingIndicator(
      size: size,
      colors: colors,
      // Use the orbit animation
      indicatorType: Indicator.orbit,
      // Transparent background
      backgroundColor: Colors.transparent,
    );
  }
}

/// A custom loading indicator widget that displays a ball scale multiple-style loading animation.
class BallScaleMultipleLoadingView extends StatelessWidget {
  // Optional size of the loading indicator
  final double? size;
  // Optional list of colors for the loading animation
  final List<Color>? colors;

  const BallScaleMultipleLoadingView({super.key, this.size, this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomLoadingIndicator(
      size: size,
      colors: colors,
      // Transparent background
      backgroundColor: Colors.transparent,
      // Use the ball scale multiple animation
      indicatorType: Indicator.ballScaleMultiple,
    );
  }
}

/// A reusable loading indicator widget that can display various types of loading animations.
class CustomLoadingIndicator extends StatelessWidget {
  // Optional size of the loading indicator
  final double? size;
  // Optional list of colors for the loading animation
  final List<Color>? colors;
  // Optional background color of the container
  final Color? backgroundColor;
  // Optional type of loading animation
  final Indicator? indicatorType;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [FlexibleElevatedButton] with the given parameters.
  ///
  /// - [title]: The label (text) displayed on the button. If provided, `child` will be ignored.
  /// - [child]: The child widget to display inside the button. If `label` is provided, this will be ignored.
  /// - [isLoading]: Whether the button is in a loading state (default: `false`).
  /// - [maxLines]: The maximum number of lines for the button's label text (only applicable if `label` is provided).
  /// - [textColor]: The color of the button's label text (only applicable if `label` is provided).
  /// - [textStyle]: The text style for the button's label (only applicable if `label` is provided).
  /// - [backgroundColor]: The background color of the button.
  /// - [buttonStyle]: The custom button style (overrides default styles if provided).
  /// - [onPressed]: Callback function triggered when the button is pressed.
  /// - [padding]: The padding around the button's content.
  ///
  const CustomLoadingIndicator({
    super.key,
    this.size,
    this.colors,
    this.backgroundColor,
    this.indicatorType,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    return Container(
      // Default size is 50 if not provided
      width: size ?? 60,
      // Default size is 50 if not provided
      height: size ?? 60,
      decoration: ShapeDecoration(
        // Circular shape for the container
        shape: const StadiumBorder(),
        // Use theme's primary color if background color is not provided
        color: backgroundColor ?? Theme.of(context).primaryColor,
      ),
      // Center the loading indicator
      alignment: Alignment.center,
      child: LoadingIndicator(
        // Width of the loading animation stroke
        strokeWidth: 2,
        // Background color of the loading path
        pathBackgroundColor: Theme.of(context).primaryColor,
        // Transparent background for the loading indicator
        backgroundColor: Colors.transparent,
        colors: colors ??
            [
              // Default colors if not provided
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              AppColors.white,
            ],
        // Default animation type if not provided
        indicatorType: indicatorType ?? Indicator.ballClipRotateMultiple,
      ),
    );
  }
}
