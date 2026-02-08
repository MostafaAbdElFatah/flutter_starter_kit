import 'package:flutter/services.dart';

/// This class is used to store all the font families.
///
/// By using this class, we can avoid using hardcoded strings in the code.
/// This makes it easier to manage and update the font families.
///
/// Example:
/// ```dart
/// Text(
///   'Hello World',
///   style: TextStyle(fontFamily: Fonts.primary),
/// );
/// ```
///
/// Supported font weights with their Flutter [FontWeight] and asset suffix.
///
/// The [assetName] must match the file naming convention in assets, e.g.
/// `Cairo-SemiBold.ttf` uses [FontWeights.semiBold] with `assetName == SemiBold`.
enum FontWeights {
  thin(FontWeight.w100, 'Thin'),
  extraLight(FontWeight.w200, 'ExtraLight'),
  light(FontWeight.w300, 'Light'),
  regular(FontWeight.w400, 'Regular'),
  medium(FontWeight.w500, 'Medium'),
  semiBold(FontWeight.w600, 'SemiBold'),
  bold(FontWeight.w700, 'Bold'),
  extraBold(FontWeight.w800, 'ExtraBold'),
  black(FontWeight.w900, 'Black');

  /// Flutter font weight used by text styles.
  final FontWeight weight;

  /// Suffix used in the font asset filename.
  final String assetName;

  const FontWeights(this.weight, this.assetName);
}

/// Supported font file extensions and their MIME types.
///
/// This is used when building `data:` URIs for embedded fonts.
enum FontExtension {
  ttf('ttf', 'font/ttf'),
  otf('otf', 'font/otf');

  /// File extension without the dot, e.g. `ttf`.
  final String value;

  /// MIME type used for `data:` URIs.
  final String mimeType;

  const FontExtension(this.value, this.mimeType);
}

/// Font families available in the app and their associated file extensions.
///
/// The [name] should match the font family name as registered in `pubspec.yaml`.
enum FontFamily {
  cairo('Cairo', FontExtension.ttf),
  poppins('Poppins', FontExtension.otf);

  /// Display name of the font family, also used in asset filenames.
  final String name;

  /// File extension used by this font family.
  final FontExtension extension;

  const FontFamily(this.name, this.extension);

  /// Default font family for the app.
  static FontFamily get primary => cairo;

  /// Base folder containing font assets.
  static const String assetPath = 'assets/fonts';

  /// Loads the font asset for the given [weight] and returns a `data:` URI.
  ///
  /// The asset path is built as:
  /// `assets/fonts/<FamilyName>/<FamilyName>-<Weight>.<ext>`
  Future<String> fontUri([FontWeights weight = FontWeights.regular]) async {
    final fileName = '$name-${weight.assetName}.${extension.value}';
    final fontData = await rootBundle.load('$assetPath/${name.toLowerCase()}/$fileName');

    return Uri.dataFromBytes(
      fontData.buffer.asUint8List(
        fontData.offsetInBytes,
        fontData.lengthInBytes,
      ),
      mimeType: extension.mimeType,
    ).toString();
  }
}
