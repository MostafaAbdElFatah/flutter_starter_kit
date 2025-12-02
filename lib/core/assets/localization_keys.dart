import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

/// This class holds all the localization keys for the application.
///
/// Using this class provides a centralized and type-safe way to manage
/// translations, preventing the use of hardcoded strings in the UI.
///
/// ## Usage
///
/// Simply access the desired string via a static getter:
///
/// ```dart
/// Text(LocalizationKeys.welcome)
/// ```
///
/// For strings with arguments, use the corresponding method:
///
/// ```dart
/// Text(LocalizationKeys.msgArgs(name: 'John', type: 'User'))
/// ```
///
/// To access raw (non-localized) error keys, use the [ErrorLocalizationKeys] class.
abstract class LocalizationKeys {
  // Private constructor to prevent instantiation.
  LocalizationKeys._();

  // ===========================================================================
  // General
  // ===========================================================================

  static get appName => 'appName'.tr();
  static get welcome => 'welcome'.tr();
  static get welcomeFlutterStarterKit => "welcomeFlutterStarterKit".tr();
  static get getStarted => 'getStarted'.tr();
  static get next => 'next'.tr();
  static get skip => 'skip'.tr();
  static get changeLanguage => 'changeLanguage'.tr();
  static get settings => 'settings'.tr();

  // ===========================================================================
  // Onboarding
  // ===========================================================================

  static get onboardingTitle1 => 'onboardingTitle1'.tr();
  static get onboardingDesc1 => 'onboardingDesc1'.tr();
  static get onboardingTitle2 => 'onboardingTitle2'.tr();
  static get onboardingDesc2 => 'onboardingDesc2'.tr();
  static get onboardingTitle3 => 'onboardingTitle3'.tr();
  static get onboardingDesc3 => 'onboardingDesc3'.tr();

  // ===========================================================================
  // Home
  // ===========================================================================

  static get homeTitle => 'homeTitle'.tr();

  // ===========================================================================
  // Auth
  // ===========================================================================

  static get login => 'login'.tr();
  static get register => 'register'.tr();
  static get email => 'email'.tr();
  static get password => 'password'.tr();
  static get confirmPassword => 'confirmPassword'.tr();
  static get forgotPassword => 'forgotPassword'.tr();
  static get name => 'name'.tr();
  static get dontHaveAccount => "dontHaveAnAccount".tr();
  static get alreadyHaveAccount => "alreadyHaveAnAccount".tr();

  // ===========================================================================
  // Errors
  // ===========================================================================

  static get error => ErrorKeys.error.tr();
  static get cancelError => ErrorKeys.cancelError.tr();
  static get invalidDataError => ErrorKeys.invalidDataError.tr();
  static get badRequestError => ErrorKeys.badRequestError.tr();
  static get noContent => ErrorKeys.noContent.tr();
  static get forbiddenError => ErrorKeys.forbiddenError.tr();
  static get internalServerError => ErrorKeys.internalServerError.tr();
  static get unauthorizedError => ErrorKeys.unauthorizedError.tr();
  static get notFoundError => ErrorKeys.notFoundError.tr();
  static get conflictError => ErrorKeys.conflictError.tr();
  static get unknownError => ErrorKeys.unknownError.tr();
  static get timeoutError => ErrorKeys.timeoutError.tr();
  static get cacheError => ErrorKeys.cacheError.tr();
  static get noInternetError => ErrorKeys.noInternetError.tr();
  static get noConnectionError => ErrorKeys.noConnectionError.tr();
  static get pleaseMakeSureConnectedToInInternet =>
      ErrorKeys.pleaseMakeSureConnectedToInternet.tr();

  // ===========================================================================
  // easy_localization examples
  // ===========================================================================

  static get hello => 'example.hello'.tr();
  static get world => 'example.world'.tr();
  static get helloWorld => 'example.helloWorld'.tr();

  /// Example of a message with positional arguments.
  /// Expects a translation string like: "My name is {} and I am a {}."
  static String msgArgs({required dynamic name, required dynamic type}) =>
      'msg'.tr(args: ['$name', '$type']);

  /// Example of a message with named arguments.
  /// Expects a translation string like: "My name is {name} and I am a {type}."
  static String msgNamed({required dynamic name, required dynamic type}) =>
      'msg_named'.tr(namedArgs: {'name': '$name', 'type': '$type'});

  /// Example of a message with both positional and named arguments.
  /// Expects a translation string like: "{} is a {lang} localization package."
  static String msgMixed({required dynamic name, required dynamic type}) =>
      'msg_mixed'.tr(args: ['Easy localization'], namedArgs: {'lang': 'Dart'});

  /// Example of gender-based translation.
  /// Expects a translation string like: "gender": {"male": "He", "female": "She"}
  static get gender => 'gender'.tr();
  static String genderBool(bool male) =>
      'gender'.tr(gender: male ? "male" : "female");

  /// Example of pluralization based on a number.
  /// Expects a translation string like: "day": {"zero": "0 days", "one": "1 day", "two": "2 days", "other": "{} days"}
  static String day(int day) => 'day'.plural(day);

  /// Example of pluralization with number formatting.
  /// Expects a translation string like: "money": {"one": "You have {} dollar", "other": "You have {} dollars"}
  /// Example for 10.23 output: You have 10.23 dollars
  static String money(double money) => 'money'.plural(money);

  /// Example of pluralization with positional arguments.
  /// Expects a translation string like: "money_args": {"one": "{} has {} dollar", "other": "{} has {} dollars"}
  /// Example output: John has 10.23 dollars
  static String moneyArgs(double money) =>
      'money_args'.plural(money, args: ['John', '10.23']);

  /// Example of pluralization with named arguments.
  /// Expects a translation string like: "money_named_args": {"one": "{name} has {money} dollar", "other": "{name} has {money} dollars"}
  /// Example output: Jane has 10.23 dollars
  static String moneyNamedArgs(double money) => 'money_named_args'.plural(
        money,
        namedArgs: {'name': 'Jane', 'money': '10.23'},
      );

  /// Example of pluralization with compact number formatting.
  /// Expects a translation string like: "money": {"one": "You have {} dollar", "other": "You have {} dollars"}
  /// Example for 1000000 output: You have 1M dollars
  static String moneyFormatCompact(double money, {required Locale locale}) =>
      'money'.plural(
        money,
        format: NumberFormat.compact(locale: locale.toString()),
      );

  /// Example of using arguments with a date.
  /// Expects a translation string like: "INFO: the date today is {currentDate}."
  /// Example Output: INFO: the date today is 2020-11-27T16:40:42.657.
  static String dateLogging() => 'dateLogging'.tr(
        namedArgs: {'currentDate': DateTime.now().toIso8601String()},
      );
}

/// Raw error message keys (non-localized).
/// Use these for error handling logic that needs the key itself.
abstract class ErrorKeys {
  ErrorKeys._();

  static const String error = 'error';
  static const String cancelError = 'cancelError';
  static const String invalidDataError = 'invalidDataError';
  static const String badRequestError = 'badRequestError';
  static const String noContent = 'noContent';
  static const String forbiddenError = 'forbiddenError';
  static const String internalServerError = 'internalServerError';
  static const String unauthorizedError = 'unauthorizedError';
  static const String unauthorizedServerError = 'unauthorizedServerError';
  static const String notFoundError = 'notFoundError';
  static const String conflictError = 'conflictError';
  static const String unknownError = 'unknownError';
  static const String timeoutError = 'timeoutError';
  static const String cacheError = 'cacheError';
  static const String noInternetError = 'noInternetError';
  static const String noConnectionError = 'noConnectionError';
  static const String pleaseMakeSureConnectedToInternet =
      'pleaseMakeSureConnectedToInternet';
}

