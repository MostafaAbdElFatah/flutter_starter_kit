import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' hide Environment;

import '../../../../core/infrastructure/domain/entities/no_params.dart';
import '../../domain/entities/api_config.dart';
import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/base_url_type.dart';
import '../../domain/entities/environment.dart';
import '../../domain/usecases/developer_login_usecase.dart';
import '../../domain/usecases/get_current_config_use_case.dart';
import '../../domain/usecases/get_current_environment_use_case.dart';
import '../../domain/usecases/get_environment_config_use_case.dart';
import '../../domain/usecases/update_environment_configuration_use_case.dart';

part 'environment_cubit_impl.dart';
part 'environment_state.dart';

/// An abstract class defining the contract for the [EnvironmentCubit].
///
/// This contract ensures that any implementation of the [EnvironmentCubit] provides
/// a standardized interface for managing the app's environment configuration.
abstract class EnvironmentCubit extends Cubit<EnvironmentState> {
  /// Creates an [EnvironmentCubit] instance with an initial state.
  EnvironmentCubit(super.initialState);

  /// A static helper method to retrieve the [EnvironmentCubit] instance from the widget tree.
  static EnvironmentCubit of(context) => BlocProvider.of(context);

  /// Initializes the cubit by loading the current configuration.
  void init();

  /// Attempts to log in as a developer with the given credentials.
  ///
  /// Returns `true` if the credentials are valid, otherwise `false`.
  bool loginAsDeveloper({required String username, required String password});

  /// Updates the application's environment and/or base URL configuration.
  Future<void> updateConfiguration({String? baseUrl});

  /// Switches the application's environment to the specified [environment].
  ///
  /// This is a convenience method that updates the environment and typically
  /// resets the base URL configuration to its default for the new environment.
  /// The application will need to be restarted for the change to take full effect.
  ///
  /// ### Parameters:
  /// - `environment`: The target [Environment] to switch to.
  void switchEnvironmentConfiguration(Environment environment);

  void onBaseUrlTypeChanged(BaseUrlType newBaseUrlType);
}
