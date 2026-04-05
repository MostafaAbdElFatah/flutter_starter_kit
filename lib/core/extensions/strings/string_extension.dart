import 'package:flutter/services.dart';

import '../../assets/fonts.dart';

/// Extension methods for the [String] class to handle common
/// formatting and conversion tasks.
extension StringX on String {
  /// Extracts only the numeric digits from a string.
  ///
  /// Useful for sanitizing phone number inputs before sending to an API.
  ///
  /// Example: `"+1 (555) 000-1234".formatPhone` returns `"15550001234"`.
  String get formatPhone {
    // Note: Replaced 'input' with 'this' to reference the current string.
    return replaceAll(RegExp(r'\D'), '');
  }

  /// Formats a numeric string into an international phone format.
  ///
  /// Default [countryCode] is '966' (Saudi Arabia).
  ///
  /// Returns the original string if the length or country code
  /// doesn't match the expected pattern.
  ///
  /// Format result: `(+966) 50-123-1234`
  String formatPhoneInternational({String countryCode = '966'}) {
    // Remove everything except digits
    final digits = replaceAll(RegExp(r'\D'), '');

    // Expecting: countryCode + 9 digits (e.g. 966501231234)
    if (digits.length < 9)
      return this; // Fallback if input doesn't meet minimum length

    final part1 = substring(0, 2); // 50
    final part2 = substring(2, 5); // 123
    final part3 = substring(5, 9); // 1234

    return '(+$countryCode) $part1-$part2-$part3';
  }

  /// Converts a Hex color string into a Flutter [Color] object.
  ///
  /// Supports both 6-character (RRGGBB) and 7-character (#RRGGBB) formats.
  /// It automatically adds 'ff' (full opacity) if an alpha channel is missing.
  ///
  /// Throws a [FormatException] if the string is not a valid hex color.
  Color get color {
    final buffer = StringBuffer();
    // If it's a standard 6-char hex, prepend 'ff' for 100% opacity
    if (length == 6 || (length == 7 && startsWith('#'))) {
      buffer.write('ff');
    }
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension StringUtils on String {
  String get capitalized => this[0].toUpperCase() + substring(1);

  Future<String> get html async =>
      """
<!DOCTYPE html>
<html lang="ar" dir="rtl">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            @font-face
            {
                font-family: 'Cairo';
                src: url(${await FontFamily.cairo.fontUriByWeight(FontWeights.medium)} );
            }
            html, body {
                  margin: 0;
                  padding: 0;
                  background-color: transparent;
            }
            
          body {
            font-family: 'Cairo';
            font-size: ${14}px;
            color: #ffffff;
            direction: rtl;
          }
      
          p, div, span {
            color: #ffffff;
            text-align: justify;
            text-justify: inter-word;
            line-height: 1.7;
          }
        </style>
    </head>
    <body>
        $this
    </body>
</html>
        """;
}
