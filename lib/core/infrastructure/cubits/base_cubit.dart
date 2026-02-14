import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/operation_runner.dart';

/// A generic base Cubit that can be extended by all feature-specific cubits.
///
/// Provides:
/// - A static `of` helper for convenient access from the widget tree.
/// - Optional cancellation helpers to avoid stale async emits.
abstract class BaseCubit<StateType> extends Cubit<StateType>
    with OperationRunner {
  BaseCubit(super.initialState);

  /// Retrieves the cubit instance from the widget tree.
  static T of<T extends Cubit<dynamic>>(
      BuildContext context, {
        bool listen = false,
      }) => BlocProvider.of<T>(context, listen: listen);

  /// Emits [state] only if the cubit is still open.
  ///
  /// Returns `true` when the state is emitted, `false` if the cubit is closed.
  bool tryEmit(StateType state) {
    if (!isClosed) emit(state);
    return !isClosed;
  }

  /// Prevents emitting after the cubit is closed.
  @override
  void emit(StateType state) {
    if (!isClosed) super.emit(state);
  }

  /// Cancels any in-flight operations before closing the cubit.
  @override
  Future<void> close() async {
    await cancelLatestOperations();
    return super.close();
  }
}

/// Convenience extension for accessing a cubit from a [BuildContext].
extension CubitX<T extends Cubit<dynamic>> on BuildContext {
  T get cubit => BlocProvider.of<T>(this);
}
