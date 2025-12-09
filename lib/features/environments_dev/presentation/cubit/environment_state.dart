part of 'environment_cubit.dart';

/// A sealed class representing the different states of the environment configuration.
///
/// Using a sealed class allows for exhaustive pattern matching in the UI,
/// ensuring that all possible states are handled.
sealed class EnvironmentState extends Equatable {
  const EnvironmentState();

  @override
  List<Object> get props => [];
}

/// The initial state, before any configuration has been loaded.
final class EnvironmentInitial extends EnvironmentState {
  const EnvironmentInitial();
}

/// The state indicating that a configuration operation is in progress.
final class EnvironmentLoading extends EnvironmentState {
  const EnvironmentLoading();
}

/// The state representing a successfully loaded configuration.
///
/// This state holds the current [AppConfig] so the UI can display it.
final class EnvironmentLoaded extends EnvironmentState {
  final APIConfig config;

  const EnvironmentLoaded(this.config);

  @override
  List<Object> get props => [config];
}
