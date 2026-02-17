import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/di/injection.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/responsive/responsive_layout.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: di.get<AppRouter>().router,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      localeListResolutionCallback: (locales, supportedLocales) {
        di.appLocaleState.current = context.locale;
        return context.locale;
      },
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
          child: ResponsiveScope(
            context: context,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
