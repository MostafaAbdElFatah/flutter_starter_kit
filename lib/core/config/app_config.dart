enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String appName;

  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
  });

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;
}
