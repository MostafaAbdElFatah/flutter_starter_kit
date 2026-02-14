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
  // Common
  // ===========================================================================

  static String get ok => 'ok'.tr();
  static String get yes => 'yes'.tr();
  static String get no => 'no'.tr();
  static String get save => 'save'.tr();
  static String get confirm => 'confirm'.tr();
  static String get cancel => 'cancel'.tr();
  static String get delete => 'delete'.tr();
  static String get next => 'next'.tr();
  static String get skip => 'skip'.tr();

  // ===========================================================================
  // Errors
  // ===========================================================================

  static String get error => ErrorKeys.error.tr();
  static String get cancelError => ErrorKeys.cancelError.tr();
  static String get invalidDataError => ErrorKeys.invalidDataError.tr();
  static String get badRequestError => ErrorKeys.badRequestError.tr();
  static String get noContent => ErrorKeys.noContent.tr();
  static String get forbiddenError => ErrorKeys.forbiddenError.tr();
  static String get internalServerError => ErrorKeys.internalServerError.tr();
  static String get unauthorizedError => ErrorKeys.unauthorizedError.tr();
  static String get notFoundError => ErrorKeys.notFoundError.tr();
  static String get conflictError => ErrorKeys.conflictError.tr();
  static String get unknownError => ErrorKeys.unknownError.tr();
  static String get timeoutError => ErrorKeys.timeoutError.tr();
  static String get cacheError => ErrorKeys.cacheError.tr();
  static String get noInternetError => ErrorKeys.noInternetError.tr();
  static String get noConnectionError => ErrorKeys.noConnectionError.tr();
  static String get pleaseMakeSureConnectedToInInternet =>
      ErrorKeys.pleaseMakeSureConnectedToInternet.tr();

  // ===========================================================================
// Error States & Messages - Usage
// ===========================================================================

  static String get deadEnd => "deadEnd".tr();
  static String get pageNotFoundMessage => "pageNotFoundMessage".tr();
  static String get articleNotFound => "articleNotFound".tr();
  static String get articleNotFoundMessage => "articleNotFoundMessage".tr();
  static String get retry => "retry".tr();
  static String get brokenLink => "brokenLink".tr();
  static String get brokenLinkMessage => "brokenLinkMessage".tr();
  static String get goBack => "goBack".tr();
  static String get connectionFailed => "connectionFailed".tr();
  static String get connectionFailedMessage => "connectionFailedMessage".tr();
  static String get noConnection => "noConnection".tr();
  static String get noConnectionMessage => "noConnectionMessage".tr();
  static String get oops => "oops".tr();
  static String get wrongNetwork => "wrongNetwork".tr();
  static String get noFiles => "noFiles".tr();
  static String get noFilesMessage => "noFilesMessage".tr();
  static String get fileNotFound => "fileNotFound".tr();
  static String get fileNotFoundMessage => "fileNotFoundMessage".tr();
  static String get locationAccess => "locationAccess".tr();
  static String get locationAccessMessage => "locationAccessMessage".tr();
  static String get enable => "enable".tr();
  static String get hangOn => "hangOn".tr();
  static String get middleOfOcean => "middleOfOcean".tr();
  static String get refresh => "refresh".tr();
  static String get noCameraAccess => "noCameraAccess".tr();
  static String get noCameraAccessMessage => "noCameraAccessMessage".tr();
  static String get noResults => "noResults".tr();
  static String get noResultsMessage => "noResultsMessage".tr();
  static String get search => "search".tr();
  static String get paymentSuccess => "paymentSuccess".tr();
  static String get paymentSuccessMessage => "paymentSuccessMessage".tr();
  static String get paymentFailed => "paymentFailed".tr();
  static String get paymentFailedMessage => "paymentFailedMessage".tr();
  static String get tryAgain => "tryAgain".tr();
  static String get routerOffline => "routerOffline".tr();
  static String get routerOfflineMessage => "routerOfflineMessage".tr();
  static String get uhOh => "uhOh".tr();
  static String get somethingWentWrong => "somethingWentWrong".tr();
  static String get hmmm => "hmmm".tr();
  static String get fixingIssue => "fixingIssue".tr();
  static String get ohNo => "ohNo".tr();
  static String get storageNotEnough => "storageNotEnough".tr();
  static String get storageNotEnoughMessage => "storageNotEnoughMessage".tr();
  static String get manage => "manage".tr();
  static String get somethingNotRight => "somethingNotRight".tr();
  static String get somethingNotRightMessage => "somethingNotRightMessage".tr();
  static String get oopsSomethingWrong => "oopsSomethingWrong".tr();
  static String get close => "close".tr();
  static String get technicalSupport => "technicalSupport".tr();

  // ===========================================================================
  // Validation Messages
  // ===========================================================================

  // General

  static String get required => 'required'.tr();
  static String get fieldRequired => 'fieldRequired'.tr();
  static String get phoneRequired => "phoneRequired".tr();
  static String get invalidPhone => "invalidPhone".tr();

  // URL Validation
  static String get urlRequired => 'urlRequired'.tr();
  static String get invalidUrlFormat => 'invalidUrlFormat'.tr();
  static String get urlMustIncludeProtocol => 'urlMustIncludeProtocol'.tr();
  static String get urlMustUseHttpProtocol => 'urlMustUseHttpProtocol'.tr();
  static String get urlMustIncludeDomain => 'urlMustIncludeDomain'.tr();
  static String get invalidDomainName => 'invalidDomainName'.tr();

  // Email Validation
  static String get emailRequired => 'emailRequired'.tr();
  static String get invalidEmailAddress => 'invalidEmailAddress'.tr();
  static String get emailTooLong => 'emailTooLong'.tr();
  static String get emailUsernameTooLong => 'emailUsernameTooLong'.tr();

  // Password Validation
  static String get passwordRequired => 'passwordRequired'.tr();
  static String passwordMinLength(int length) =>
      'passwordMinLength'.tr(args: ['$length']);
  static String get passwordRequireUppercase => 'passwordRequireUppercase'.tr();
  static String get passwordRequireLowercase => 'passwordRequireLowercase'.tr();
  static String get passwordRequireNumber => 'passwordRequireNumber'.tr();
  static String get passwordRequireSpecialChar =>
      'passwordRequireSpecialChar'.tr();
  static String get confirmPasswordRequired => 'confirmPasswordRequired'.tr();
  static String get passwordsDoNotMatch => 'passwordsDoNotMatch'.tr();

  // Username Validation
  static String get usernameRequired => 'usernameRequired'.tr();
  static String usernameMinLength(int length) =>
      'usernameMinLength'.tr(args: ['$length']);
  static String usernameMaxLength(int length) =>
      'usernameMaxLength'.tr(args: ['$length']);
  static String usernameInvalidCharacters({
    required bool allowNumbers,
    required bool allowUnderscores,
  }) {
    String key = 'usernameInvalidCharacters';
    if (allowNumbers && allowUnderscores) {
      key = 'usernameInvalidCharactersAll';
    } else if (allowNumbers) {
      key = 'usernameInvalidCharactersNumbers';
    } else if (allowUnderscores) {
      key = 'usernameInvalidCharactersUnderscores';
    } else {
      key = 'usernameInvalidCharactersLettersOnly';
    }
    return key.tr();
  }

  // ===========================================================================
  // Onboarding
  // ===========================================================================

  static String get onboardingTitle1 => 'onboardingTitle1'.tr();
  static String get onboardingDesc1 => 'onboardingDesc1'.tr();
  static String get onboardingTitle2 => 'onboardingTitle2'.tr();
  static String get onboardingDesc2 => 'onboardingDesc2'.tr();
  static String get onboardingTitle3 => 'onboardingTitle3'.tr();
  static String get onboardingDesc3 => 'onboardingDesc3'.tr();

  // ===========================================================================
  // Auth
  // ===========================================================================

  static String get login => 'login'.tr();
  static String get register => 'register'.tr();
  static String get email => 'email'.tr();
  static String get phone => 'phone'.tr();
  static String get password => 'password'.tr();
  static String get confirmPassword => 'confirmPassword'.tr();
  static String get forgotPassword => 'forgotPassword'.tr();
  static String get name => 'name'.tr();
  static String get username => 'username'.tr();
  static String get dontHaveAccount => "dontHaveAnAccount".tr();
  static String get alreadyHaveAccount => "alreadyHaveAnAccount".tr();

  // ===========================================================================
  // Developer environment
  // ===========================================================================

  static String get developerModeEnabled => 'developerModeEnabled'.tr();
  static String get environmentConfig => 'environmentConfig'.tr();
  static String get configurationSaved => 'configurationSaved'.tr();
  static String get baseUrl => 'baseUrl'.tr();
  static String get environment => 'environment'.tr();
  static String get saveAndRestart => 'saveAndRestart'.tr();
  static String get defaultMode => 'default'.tr();
  static String get customMode => 'custom'.tr();
  static String get baseUrlConfiguration => 'baseUrlConfiguration'.tr();
  static String get developerLogin => 'developerLogin'.tr();
  static String get invalidCredentials => 'invalidCredentials'.tr();
  static String get environmentChanged => 'environmentChanged'.tr();
  static String switchedToEnv(String envName) =>
      'switchedToEnv'.tr(args: [envName]);

  // ===========================================================================
  // Home
  // ===========================================================================

  static String get welcome => 'welcome'.tr();
  static String get welcomeFlutterStarterKit => "welcomeFlutterStarterKit".tr();


  static String get homeTitle => 'homeTitle'.tr();
  static String get appName => 'appName'.tr();

  static String get getStarted => 'getStarted'.tr();
  static String get changeLanguage => 'changeLanguage'.tr();
  static String get settings => 'settings'.tr();


  // ===========================================================================
  // Account Management
  // ===========================================================================

  static String get logout => 'logout'.tr();
  static String get deleteAccount => 'deleteAccount'.tr();
  static String get deleteAccountWarning => 'deleteAccountWarning'.tr();
  static String get accountDeletedSuccessfully =>
      'accountDeletedSuccessfully'.tr();
  static String get accountDeletionFailed => 'accountDeletionFailed'.tr();

  // ===========================================================================
  // easy_localization examples
  // ===========================================================================

  static String get hello => 'example.hello'.tr();
  static String get world => 'example.world'.tr();
  static String get helloWorld => 'example.helloWorld'.tr();

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
  static String  get gender => 'gender'.tr();
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
