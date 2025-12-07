part of 'environment_cubit.dart';

/// '';
/// The concrete implementation of the [EnvironmentCubit].
///
/// This class manages the state of the environment configuration by interacting
/// with the appropriate use cases.
@Injectable(as: EnvironmentCubit)
final class EnvironmentCubitImpl extends EnvironmentCubit {
  final DeveloperLoginUseCase _developerLoginUseCase;
  final GetCurrentAppConfigUseCase _getCurrentAppConfigUseCase;
  final GetEnvironmentConfigUseCase _getEnvironmentConfigUseCase;
  final UpdateEnvironmentConfigUseCase _updateEnvironmentConfigUseCase;

  /// Creates an instance of [EnvironmentCubitImpl].
  EnvironmentCubitImpl({
    required DeveloperLoginUseCase developerLoginUseCase,
    required GetCurrentAppConfigUseCase getCurrentAppConfigUseCase,
    required GetEnvironmentConfigUseCase getEnvironmentConfigUseCase,
    required UpdateEnvironmentConfigUseCase updateEnvironmentConfigUseCase,
  }) : _developerLoginUseCase = developerLoginUseCase,
       _getCurrentAppConfigUseCase = getCurrentAppConfigUseCase,
       _getEnvironmentConfigUseCase = getEnvironmentConfigUseCase,
       _updateEnvironmentConfigUseCase = updateEnvironmentConfigUseCase,
       super(const EnvironmentInitial());

  @override
  Future<void> init() async {
    emit(const EnvironmentLoading());
    final config = _getCurrentAppConfigUseCase();
    emit(EnvironmentLoaded(config));
  }

  @override
  Future<void> updateConfiguration({
    required Environment environment,
    BaseUrlConfig? baseUrlConfig,
  }) async {
    emit(const EnvironmentLoading());
    await _updateEnvironmentConfigUseCase(
      environment,
      baseUrlConfig: baseUrlConfig,
    );
    // After updating, reload the config to ensure the UI reflects the change.
    final config = _getCurrentAppConfigUseCase();
    emit(EnvironmentLoaded(config));
  }

  @override
  void switchEnvironmentConfiguration(Environment environment) {
    emit(const EnvironmentLoading());
    final config = _getEnvironmentConfigUseCase(environment);
    emit(EnvironmentLoaded(config));
  }

  @override
  bool loginAsDeveloper({
    required String username,
    required String password,
  }) => _developerLoginUseCase(username: username, password: password);
}
