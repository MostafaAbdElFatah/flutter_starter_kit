import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../../../../core/infrastructure/presentation/cubits/base_cubit.dart';
import '../../domain/entities/api_config.dart';
import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/base_url_type.dart';
import '../../domain/entities/environment.dart';
import '../../domain/usecases/developer_login_usecase.dart';
import '../../domain/usecases/get_current_config_use_case.dart';
import '../../domain/usecases/get_current_environment_use_case.dart';
import '../../domain/usecases/get_environment_config_use_case.dart';
import '../../domain/usecases/update_environment_configuration_use_case.dart';

part 'environment_state.dart';
/// '';
/// The concrete implementation of the [EnvironmentCubit].
///
/// This class manages the state of the environment configuration by interacting
/// with the appropriate use cases.
@injectable
final class EnvironmentCubit extends BaseCubit<EnvironmentState>{
  late APIConfig _config;
  final DeveloperLoginUseCase _developerLoginUseCase;
  final GetCurrentApiConfigUseCase _getCurrentApiConfigUseCase;
  final GetEnvironmentConfigUseCase _getEnvironmentConfigUseCase;
  final GetCurrentEnvironmentUseCase _getCurrentEnvironmentUseCase;
  final UpdateEnvironmentConfigUseCase _updateEnvironmentConfigUseCase;

  /// Creates an instance of [EnvironmentCubitImpl].
  EnvironmentCubit({
    required DeveloperLoginUseCase developerLoginUseCase,
    required GetCurrentApiConfigUseCase getCurrentApiConfigUseCase,
    required GetEnvironmentConfigUseCase getEnvironmentConfigUseCase,
    required GetCurrentEnvironmentUseCase getCurrentEnvironmentUseCase,
    required UpdateEnvironmentConfigUseCase updateEnvironmentConfigUseCase,
  }) : _developerLoginUseCase = developerLoginUseCase,
        _getCurrentApiConfigUseCase = getCurrentApiConfigUseCase,
        _getEnvironmentConfigUseCase = getEnvironmentConfigUseCase,
        _getCurrentEnvironmentUseCase = getCurrentEnvironmentUseCase,
        _updateEnvironmentConfigUseCase = updateEnvironmentConfigUseCase,
        super(const EnvironmentInitial());

  /// A static helper method to retrieve the [AuthCubit] instance from the widget tree.
  ///
  /// This simplifies accessing the cubit from UI components.
  ///
  /// Example:
  /// ```dart
  /// AuthCubit.of(context).loginAsDeveloper(email: 'test@test.com', password: '123');
  /// ```
  static EnvironmentCubit of(BuildContext context, {bool listen = false}) =>
      BaseCubit.of(context, listen: listen);

  APIConfig get currentConfig => _getCurrentApiConfigUseCase(NoParams());

  /// Initializes the cubit by loading the current configuration.
  void init() {
    final environment = _getCurrentEnvironmentUseCase(NoParams());
    switchEnvironmentConfiguration(environment);
  }

  /// Attempts to log in as a developer with the given credentials.
  ///
  /// Returns `true` if the credentials are valid, otherwise `false`.
  bool loginAsDeveloper({required String username, required String password}) =>
      _developerLoginUseCase(
        DevLoginParams(username: username, password: password),
      );

  /// Updates the application's environment and/or base URL configuration.
  Future<void> updateConfiguration({String? baseUrl}) async {
    emit(const EnvironmentLoading());
    BaseUrlConfig baseUrlConfig = BaseUrlConfig.defaultUrl();
    // If custom mode is selected, set the custom base URL
    if (_config.baseUrlConfig.isCustom) {
      baseUrlConfig = BaseUrlConfig.custom(baseUrl);
    }

    await _updateEnvironmentConfigUseCase(
      EnvironmentConfigUpdateParams(
        _config.environment,
        baseUrlConfig: baseUrlConfig,
      ),
    );

    // After updating, reload the config to ensure the UI reflects the change.
    _config = _getEnvironmentConfigUseCase(
      EnvironmentConfigGetParams(_config.environment),
    );
    emit(EnvironmentLoaded(_config));
  }

  /// Switches the application's environment to the specified [environment].
  ///
  /// This is a convenience method that updates the environment and typically
  /// resets the base URL configuration to its default for the new environment.
  /// The application will need to be restarted for the change to take full effect.
  ///
  /// ### Parameters:
  /// - `environment`: The target [Environment] to switch to.
  void switchEnvironmentConfiguration(Environment environment) {
    emit(const EnvironmentLoading());
    _config = _getEnvironmentConfigUseCase(
      EnvironmentConfigGetParams(environment),
    );
    emit(EnvironmentLoaded(_config));
  }

  void onBaseUrlTypeChanged(BaseUrlType newBaseUrlType) {
    emit(const EnvironmentLoading());
    _config = _config.copyWith(
      baseUrlConfig: _config.baseUrlConfig.copyWith(type: newBaseUrlType),
    );
    emit(EnvironmentLoaded(_config));
  }
}
