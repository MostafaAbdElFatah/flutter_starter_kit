import 'package:flutter/material.dart' as ui;
import 'package:flutter/material.dart' hide TextDirection;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

enum AppLocale {
  arabic('ar'),
  english('en');

  final String code;
  const AppLocale(this.code);

  // Convert enum to Flutter Locale
  Locale get locale => Locale(code);

  // Configuration Constants
  static final String path = 'assets/translations';

  // Default locale
  static final Locale defaultLocale = AppLocale.arabic.locale;

  // Helper to get list of Locales for MaterialApp
  static List<Locale> get supportedLocales =>
      AppLocale.values.map((e) => e.locale).toList();

  /// Checks if a given locale is supported by the application
  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  /// Gets a locale by language code, returns default if not found
  static Locale getLocaleByCode(String languageCode) {
    try {
      return supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } catch (_) {
      return defaultLocale;
    }
  }

  /// Checks if the given locale is RTL (Right-to-Left)
  static bool isRTL(Locale locale) {
    return locale.languageCode == 'ar' ||
        locale.languageCode == 'he' ||
        locale.languageCode == 'fa' ||
        locale.languageCode == 'ur';
  }

  /// Returns the text direction for the given locale
  static ui.TextDirection getTextDirection(Locale locale) =>
      isRTL(locale) ? ui.TextDirection.rtl : ui.TextDirection.ltr;

  // Logic to toggle language
  static void toggle(BuildContext context) async {
    void rebirth() => Phoenix.rebirth(context);

    final currentLocale = context.locale;

    // Find current enum index
    final currentIndex = AppLocale.values.indexWhere(
      (l) => l.code == currentLocale.languageCode,
    );

    // Calculate next index (circular)
    final nextIndex = (currentIndex + 1) % AppLocale.values.length;
    final newLocale = AppLocale.values[nextIndex].locale;

    // Apply changes
    // Apply the changes
    await context.setLocale(newLocale);

    // Note: EasyLocalization automatically rebuilds the widget tree.
    // You likely do NOT need Phoenix.rebirth unless you need to reset singletons.
    rebirth();
  }
}

/// Extension methods for easier locale management
extension LocaleConfigExtension on BuildContext {
  /// Gets the current locale from context
  Locale get currentLocale => Localizations.localeOf(this);

  /// Checks if current locale is RTL
  bool get isRTL => AppLocale.isRTL(currentLocale);

  /// Gets text direction for current locale
  ui.TextDirection get textDirection =>
      AppLocale.getTextDirection(currentLocale);

  // Logic to toggle language
  void toggleLanguage() => AppLocale.toggle(this);
}
