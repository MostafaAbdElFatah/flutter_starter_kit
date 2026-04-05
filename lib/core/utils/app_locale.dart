import 'package:flutter/material.dart' as ui;
import 'package:flutter/material.dart' hide TextDirection;
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLocaleState {
  Locale current = AppLocale.defaultLocale;
}

enum AppLocale {
  arabic('ar'),
  english('en');

  final String code;
  const AppLocale(this.code);

  // Convert enum to Flutter Locale
  Locale get locale => Locale(code);

  // Configuration Constants
  static const String path = 'assets/translations';

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

  static Future<void> set(BuildContext context, AppLocale locale) async {
    await context.setLocale(locale.locale);
  }

  static Future<void> setByIsArabic(
    BuildContext context,
    bool isArabic,
  ) async {
    await set(context, isArabic ? AppLocale.arabic : AppLocale.english);
  }

  // Logic to toggle language
  static Future<void> toggle(BuildContext context) async {
    final currentLocale = context.locale;

    // Find current enum index
    final currentIndex = AppLocale.values.indexWhere(
      (l) => l.code == currentLocale.languageCode,
    );

    // Calculate next index (circular)
    final nextIndex = (currentIndex + 1) % AppLocale.values.length;
    final newLocale = AppLocale.values[nextIndex];

    // Apply changes
    await set(context, newLocale);
  }
}

/// Extension on [Locale] that provides convenience
/// getters for commonly used language checks.
extension LocaleX on Locale {
  /// Returns `true` if this locale matches the Arabic app locale.
  bool get isArabic => _matches(AppLocale.arabic);

  /// Returns `true` if this locale matches the English app locale.
  bool get isEnglish => _matches(AppLocale.english);

  /// Compares this locale with the given [AppLocale].
  bool _matches(AppLocale appLocale) => languageCode == appLocale.code;
}

/// Extension methods for easier locale management
extension LocaleConfigExtension on BuildContext {
  /// Gets the current locale from context
  Locale get currentLocale => Localizations.localeOf(this);

  /// Checks if current locale is RTL
  bool get isRTL => AppLocale.isRTL(currentLocale);

  /// Returns `true` if this locale matches the Arabic app locale.
  bool get isArabic => currentLocale.isArabic;

  /// Returns `true` if this locale matches the English app locale.
  bool get isEnglish => currentLocale.isEnglish;

  /// Gets text direction for current locale
  ui.TextDirection get textDirection =>
      AppLocale.getTextDirection(currentLocale);

  // Logic to toggle language
  void toggleLanguage() {
    AppLocale.toggle(this);
  }

  void setLanguage(bool isArabic) {
    AppLocale.setByIsArabic(this, isArabic);
  }
}
