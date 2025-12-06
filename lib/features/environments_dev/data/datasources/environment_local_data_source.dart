import '../../domain/entities/app_env_config.dart';
import '../../domain/entities/environment.dart';
import '../models/base_url_config.dart';

/// An abstract class representing the local data source for authentication.
///
/// This class defines the contract for caching authentication-related data,
/// such as the user's profile and authentication token.
abstract class EnvLocalDataSource {
  /// Retrieves the current application configuration.
  ///
  /// **Note**: This is a computed property that reads from persistent storage
  /// every time it is accessed. It fetches the saved environment and base URL
  /// configuration, then constructs and returns a new [AppConfig] instance.
  AppConfig get currentConfig;

  /// Retrieves the configuration for Environment.
  ///
  /// every time it is accessed. It fetches the saved environment and base URL
  /// configuration for this env, then constructs and returns a new [AppConfig] instance.
  AppConfig getConfigForEnvironment(Environment env);

  /// Saves the selected environment and base URL configuration to persistent storage.
  ///
  /// This method updates the stored settings for both the environment and the
  /// custom base URL. The application typically needs to be restarted for these
  /// changes to take full effect across the app.
  Future<void> updateConfiguration(
    Environment environment, {
    BaseUrlConfigModel? baseUrlConfig,
  });
}
