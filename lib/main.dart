import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'app.dart';
import 'core/di/di.dart' as di;
import 'core/utils/app_locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.setupDependencies();

  runApp(
    EasyLocalization(
      path: AppLocale.path,
      supportedLocales: AppLocale.supportedLocales,
      fallbackLocale: AppLocale.defaultLocale,
      startLocale: AppLocale.defaultLocale,
      child: Phoenix(child: const App()),
    ),
  );
}
