part of 'environment_cubit.dart';

/// '';
/// The concrete implementation of the [EnvironmentCubit].
///
/// This class manages the state of the environment configuration by interacting
/// with the appropriate use cases.
@Injectable(as: EnvironmentCubit)
final class EnvironmentCubitImpl extends EnvironmentCubit {
  late APIConfig _config;

  final DeveloperLoginUseCase _developerLoginUseCase;
  final GetCurrentApiConfigUseCase _getCurrentApiConfigUseCase;
  final GetEnvironmentConfigUseCase _getEnvironmentConfigUseCase;
  final GetCurrentEnvironmentUseCase _getCurrentEnvironmentUseCase;
  final UpdateEnvironmentConfigUseCase _updateEnvironmentConfigUseCase;

  /// Creates an instance of [EnvironmentCubitImpl].
  EnvironmentCubitImpl({
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

  APIConfig get currentConfig => _getCurrentApiConfigUseCase(NoParams());

  @override
  void init() {
    final environment = _getCurrentEnvironmentUseCase(NoParams());
    switchEnvironmentConfiguration(environment);
  }

  @override
  bool loginAsDeveloper({required String username, required String password}) =>
      _developerLoginUseCase(
        DevLoginParams(username: username, password: password),
      );

  @override
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

  @override
  void switchEnvironmentConfiguration(Environment environment) {
    emit(const EnvironmentLoading());
    _config = _getEnvironmentConfigUseCase(
      EnvironmentConfigGetParams(environment),
    );
    emit(EnvironmentLoaded(_config));
  }

  @override
  void onBaseUrlTypeChanged(BaseUrlType newBaseUrlType) {
    emit(const EnvironmentLoading());
    _config = _config.copyWith(
      baseUrlConfig: _config.baseUrlConfig.copyWith(type: newBaseUrlType),
    );
    emit(EnvironmentLoaded(_config));
  }
}
