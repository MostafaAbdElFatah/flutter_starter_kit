import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

abstract class LocaleKeys {
  // Private constructor to prevent instantiation.
  LocaleKeys._();

  static get appName => 'appName'.tr();
  static get welcome => 'welcome'.tr();
  static get welcomeFlutterStarterKit => "welcomeFlutterStarterKit".tr();
  static get onboardingTitle1 => 'onboardingTitle1'.tr();
  static get onboardingDesc1 => 'onboardingDesc1'.tr();
  static get onboardingTitle2 => 'onboardingTitle2'.tr();
  static get onboardingDesc2 => 'onboardingDesc2'.tr();
  static get onboardingTitle3 => 'onboardingTitle3'.tr();
  static get onboardingDesc3 => 'onboardingDesc3'.tr();
  static get getStarted => 'getStarted'.tr();
  static get next => 'next'.tr();
  static get skip => 'skip'.tr();
  static get homeTitle => 'homeTitle'.tr();
  static get changeLanguage => 'changeLanguage'.tr();
  static get settings => 'settings'.tr();

  static get hello => 'example.hello'.tr();
  static get world => 'example.world'.tr();
  static get helloWorld => 'example.helloWorld'.tr();

  // msg
  static String msgArgs({required dynamic name, required dynamic type}) =>
      'msg'.tr(args: ['$name', '$type']);

  static String msgNamed({required dynamic name, required dynamic type}) =>
      'msg_named'.tr(namedArgs: {'name': '$name', 'type': '$type'});

  static String msgMixed({required dynamic name, required dynamic type}) =>
      'msg_mixed'.tr(args: ['Easy localization'], namedArgs: {'lang': 'Dart'});

  static final gender = 'gender'.tr();
  static String genderBool(bool male) =>
      'gender'.tr(gender: male ? "male" : "female");

  static String day(int day) => 'day'.plural(day);

  // 10.23 output: You have 10.23 dollars
  static String money(double money) => 'money'.plural(money);

  // output: John has 10.23 dollars
  static String moneyArgs(double money) =>
      'money_args'.plural(money, args: ['John', '10.23']);

  // output: John has 10.23 dollars
  // output: Jane has 10.23 dollars
  static String moneyNamedArgs(double money) => 'money_named_args'.plural(
    money,
    namedArgs: {'name': 'Jane', 'money': '10.23'},
  );

  // 1000000 output: You have 1M dollars
  static String moneyFormatCompact(double money, {required Locale locale}) =>
      'money'.plural(
        money,
        format: NumberFormat.compact(locale: locale.toString()),
      );

  // Output: INFO: the date today is 2020-11-27T16:40:42.657.
  static String dateLogging(double money) => 'dateLogging'.tr(
    namedArgs: {'currentDate': DateTime.now().toIso8601String()},
  );
}
