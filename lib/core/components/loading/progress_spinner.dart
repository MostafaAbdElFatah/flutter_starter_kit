import 'package:flutter/material.dart';

/// A customizable progress spinner widget.
///
/// The [ProgressSpinner] widget displays a circular progress indicator with
/// optional customization for color, size, and stroke width. It is designed to
/// be reusable and integrates seamlessly with the app's theme.
class ProgressSpinner extends StatelessWidget {
  // ================================
  //        Widget Parameters
  // ================================

  /// The color of the progress indicator.
  ///
  /// If not specified, it defaults to the primary color defined in the current theme.
  final Color? color;

  /// The width and height of the spinner.
  ///
  /// This defines the size of the spinner in logical pixels.
  /// Defaults to 40.0 if not provided.
  final double size;

  /// The width of the spinner's stroke.
  ///
  /// This defines how thick the spinner's line is.
  /// Defaults to 1.0 if not provided.
  final double strokeWidth;

  // ================================
  //        Constructor
  // ================================

  /// Creates a [ProgressSpinner].
  ///
  /// - [color]: The color of the progress indicator. Defaults to the theme's primary color if not provided.
  /// - [size]: The width and height of the spinner. Defaults to 40 logical pixels.
  /// - [strokeWidth]: The width of the spinner's stroke. Defaults to 1.0.
  const ProgressSpinner({
    super.key,
    this.color,
    this.size = 40.0,
    this.strokeWidth = 2.0,
  });

  // ================================
  //            Build
  // ================================

  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme to access theme-based colors
    final theme = Theme.of(context);

    return SizedBox(
      width: size, // Set the width of the spinner
      height: size, // Set the height of the spinner
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth, // Set the stroke width of the spinner
        color: color ??
            theme.primaryColor, // Set the color, defaulting to primary color
      ),
    );
  }
}
