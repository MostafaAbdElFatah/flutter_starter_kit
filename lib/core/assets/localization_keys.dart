import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

/// This class holds all the localization keys for the application.
///
/// Using this class provides a centralized and type-safe way to manage
/// translations, preventing the use of hardcoded strings in the UI.
///
/// ## Usage
///
/// Simply access the desired string via a constgetter:
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

  static const String ok = 'ok';
  static const String yes = 'yes';
  static const String no = 'no';
  static const String save = 'save';
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String next = 'next';
  static const String skip = 'skip';

  // ===========================================================================
  // Errors
  // ===========================================================================

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

  // ===========================================================================
  // Error States & Messages - Usage
  // ===========================================================================

  static const String deadEnd = "deadEnd";
  static const String pageNotFoundMessage = "pageNotFoundMessage";
  static const String articleNotFound = "articleNotFound";
  static const String articleNotFoundMessage = "articleNotFoundMessage";
  static const String retry = "retry";
  static const String brokenLink = "brokenLink";
  static const String brokenLinkMessage = "brokenLinkMessage";
  static const String goBack = "goBack";
  static const String connectionFailed = "connectionFailed";
  static const String connectionFailedMessage = "connectionFailedMessage";
  static const String noConnection = "noConnection";
  static const String noConnectionMessage = "noConnectionMessage";
  static const String oops = "oops";
  static const String wrongNetwork = "wrongNetwork";
  static const String noFiles = "noFiles";
  static const String noFilesMessage = "noFilesMessage";
  static const String fileNotFound = "fileNotFound";
  static const String fileNotFoundMessage = "fileNotFoundMessage";
  static const String locationAccess = "locationAccess";
  static const String locationAccessMessage = "locationAccessMessage";
  static const String enable = "enable";
  static const String hangOn = "hangOn";
  static const String middleOfOcean = "middleOfOcean";
  static const String refresh = "refresh";
  static const String noCameraAccess = "noCameraAccess";
  static const String noCameraAccessMessage = "noCameraAccessMessage";
  static const String noResults = "noResults";
  static const String noResultsMessage = "noResultsMessage";
  static const String search = "search";
  static const String paymentSuccess = "paymentSuccess";
  static const String paymentSuccessMessage = "paymentSuccessMessage";
  static const String paymentFailed = "paymentFailed";
  static const String paymentFailedMessage = "paymentFailedMessage";
  static const String tryAgain = "tryAgain";
  static const String routerOffline = "routerOffline";
  static const String routerOfflineMessage = "routerOfflineMessage";
  static const String uhOh = "uhOh";
  static const String somethingWentWrong = "somethingWentWrong";
  static const String hmmm = "hmmm";
  static const String fixingIssue = "fixingIssue";
  static const String ohNo = "ohNo";
  static const String storageNotEnough = "storageNotEnough";
  static const String storageNotEnoughMessage = "storageNotEnoughMessage";
  static const String manage = "manage";
  static const String somethingNotRight = "somethingNotRight";
  static const String somethingNotRightMessage = "somethingNotRightMessage";
  static const String oopsSomethingWrong = "oopsSomethingWrong";
  static const String close = "close";
  static const String technicalSupport = "technicalSupport";

  // ===========================================================================
  // Validation Messages
  // ===========================================================================

  // General

  static const String required = 'required';
  static const String fieldRequired = 'fieldRequired';
  static const String phoneRequired = "phoneRequired";
  static const String invalidPhone = "invalidPhone";

  // URL Validation
  static const String urlRequired = 'urlRequired';
  static const String invalidUrlFormat = 'invalidUrlFormat';
  static const String urlMustIncludeProtocol = 'urlMustIncludeProtocol';
  static const String urlMustUseHttpProtocol = 'urlMustUseHttpProtocol';
  static const String urlMustIncludeDomain = 'urlMustIncludeDomain';
  static const String invalidDomainName = 'invalidDomainName';

  // Email Validation
  static const String emailRequired = 'emailRequired';
  static const String invalidEmailAddress = 'invalidEmailAddress';
  static const String emailTooLong = 'emailTooLong';
  static const String emailUsernameTooLong = 'emailUsernameTooLong';

  // Password Validation
  static const String passwordRequired = 'passwordRequired';
  static String passwordMinLength(int length) =>
      'passwordMinLength'.tr(args: ['$length']);
  static const String passwordRequireUppercase = 'passwordRequireUppercase';
  static const String passwordRequireLowercase = 'passwordRequireLowercase';
  static const String passwordRequireNumber = 'passwordRequireNumber';
  static const String passwordRequireSpecialChar = 'passwordRequireSpecialChar';
  static const String confirmPasswordRequired = 'confirmPasswordRequired';
  static const String passwordsDoNotMatch = 'passwordsDoNotMatch';

  // Username Validation
  static const String usernameRequired = 'usernameRequired';
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
    return key;
  }

  // ===========================================================================
  // Onboarding
  // ===========================================================================

  static const String onboardingTitle1 = 'onboardingTitle1';
  static const String onboardingDesc1 = 'onboardingDesc1';
  static const String onboardingTitle2 = 'onboardingTitle2';
  static const String onboardingDesc2 = 'onboardingDesc2';
  static const String onboardingTitle3 = 'onboardingTitle3';
  static const String onboardingDesc3 = 'onboardingDesc3';

  // ===========================================================================
  // Auth
  // ===========================================================================

  static const String login = 'login';
  static const String register = 'register';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String password = 'password';
  static const String confirmPassword = 'confirmPassword';
  static const String forgotPassword = 'forgotPassword';
  static const String name = 'name';
  static const String username = 'username';
  static const String dontHaveAccount = "dontHaveAnAccount";
  static const String alreadyHaveAccount = "alreadyHaveAnAccount";

  // ===========================================================================
  // Developer environment
  // ===========================================================================

  static const String developerModeEnabled = 'developerModeEnabled';
  static const String environmentConfig = 'environmentConfig';
  static const String configurationSaved = 'configurationSaved';
  static const String baseUrl = 'baseUrl';
  static const String environment = 'environment';
  static const String saveAndRestart = 'saveAndRestart';
  static const String defaultMode = 'default';
  static const String customMode = 'custom';
  static const String baseUrlConfiguration = 'baseUrlConfiguration';
  static const String developerLogin = 'developerLogin';
  static const String invalidCredentials = 'invalidCredentials';
  static const String environmentChanged = 'environmentChanged';
  static String switchedToEnv(String envName) =>
      'switchedToEnv'.tr(args: [envName]);

  // ===========================================================================
  // Home
  // ===========================================================================

  static const String welcome = 'welcome';
  static const String welcomeFlutterStarterKit = "welcomeFlutterStarterKit";

  static const String homeTitle = 'homeTitle';
  static const String appName = 'appName';

  static const String getStarted = 'getStarted';
  static const String changeLanguage = 'changeLanguage';
  static const String settings = 'settings';

  // ===========================================================================
  // Account Management
  // ===========================================================================

  static const String logout = 'logout';
  static const String deleteAccount = 'deleteAccount';
  static const String deleteAccountWarning = 'deleteAccountWarning';
  static const String accountDeletedSuccessfully = 'accountDeletedSuccessfully';
  static const String accountDeletionFailed = 'accountDeletionFailed';

  // ===========================================================================
  // easy_localization examples
  // ===========================================================================

  static const String hello = 'example.hello';
  static const String world = 'example.world';
  static const String helloWorld = 'example.helloWorld';

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
  static const String gender = 'gender';
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
