import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc/bloc.dart';


import '../../core.dart';
import '../common/operation_runner.dart';


/// A generic base Bloc that can be extended by all feature-specific blocs.
///
/// Provides:
/// - A static `of` helper for convenient access from the widget tree.
/// - Optional cancellation helpers to avoid stale async emits.
abstract class BaseBloc<EventType, StateType>
    extends Bloc<EventType, StateType> with OperationRunner {
  BaseBloc(super.initialState);

  /// Retrieves the bloc instance from the widget tree.
  static T of<T extends Bloc<dynamic, dynamic>>(
    BuildContext context, {
    bool listen = false,
  }) => BlocProvider.of<T>(context, listen: listen);

  // Helper function for debouncing
  EventTransformer<T> debounce<T>([Duration duration = const Duration(milliseconds: 300)]) {
    return (events, mapper) => events.debounce(duration).switchMap(mapper);
  }

  /// Emits [state] only if the bloc is still open.
  ///
  /// Returns `true` when the state is emitted, `false` if the bloc is closed.
  bool tryEmit(Emitter<StateType> emit, StateType state) {
    if (!isClosed) emit(state);
    return !isClosed;
  }

  /// Cancels any in-flight operations before closing the bloc.
  @override
  Future<void> close() async {
    await cancelLatestOperations();
    return super.close();
  }
}

/// Convenience extension for accessing a bloc from a [BuildContext].
extension BlocX<T extends Bloc<dynamic, dynamic>> on BuildContext {
  T get bloc => BlocProvider.of<T>(this);
}

/// Safe emitter extension for blocs.
extension EmitterX<StateType> on Emitter<StateType> {
  /// Emits [state] only if the bloc is still open.
  ///
  /// Returns `true` when the state is emitted, `false` if the bloc is closed.
  bool tryEmit(BlocBase<dynamic> bloc, StateType state) {
    if (!bloc.isClosed) call(state);
    return !bloc.isClosed;
  }
}
