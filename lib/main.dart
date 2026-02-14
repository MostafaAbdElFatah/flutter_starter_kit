import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/utils/app_locale.dart';
import 'core/di/injection.dart' as injection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await injection.configureDependencies();
  // ErrorWidget.builder = (FlutterErrorDetails details) =>
  //     ErrorPage(details: details);

  runApp(
    EasyLocalization(
      path: AppLocale.path,
      supportedLocales: AppLocale.supportedLocales,
      fallbackLocale: AppLocale.defaultLocale,
      startLocale: AppLocale.defaultLocale,
      child: Phoenix(
        child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          //fontSizeResolver:,
          //designSize: context.defaultSize,
          builder: (context, child) => App(),
        ),
      ),
    ),
  );
}
