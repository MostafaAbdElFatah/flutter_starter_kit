import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';

/// A generic base Cubit that can be extended by all feature-specific cubits.
///
/// Provides:
/// - A static `of` helper for convenient access from the widget tree.
/// - Optional cancellation helpers to avoid stale async emits.
abstract class BaseCubit<StateType> extends Cubit<StateType> {
  BaseCubit(super.initialState);

  /// Tracks in-flight async operations keyed by a semantic action name.
  final Map<Object, CancelableOperation<dynamic>> _latestOperations = {};

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

  /// Runs the latest async operation for [key], canceling any previous one.
  ///
  /// This is useful when only the newest request should win (e.g., login).
  /// The returned [OperationResult] lets you distinguish cancellation from
  /// a legitimate `null` value when `T` itself is nullable. For `Future<void>`
  /// operations, check [OperationResult.isCanceled] and ignore the value.
  @protected
  Future<OperationResult> runLatest<T>(Object key, Future<T> future) async {
    final existing = _latestOperations.remove(key);
    if (existing != null) {
      await existing.cancel();
    }

    final operation = CancelableOperation<T>.fromFuture(future);
    _latestOperations[key] = operation;

    try {
      final result = await operation.valueOrCancellation();
      if (operation.isCanceled) return const OperationCanceled();
      return OperationSuccess<T>(result as T);
    } finally {
      if (_latestOperations[key] == operation) {
        _latestOperations.remove(key);
      }
    }
  }

  /// Cancels any in-flight operations before closing the cubit.
  @override
  Future<void> close() async {
    final operations = _latestOperations.values.toList(growable: false);
    _latestOperations.clear();
    for (final operation in operations) {
      await operation.cancel();
    }
    return super.close();
  }
}

/// The result of a cancellable async operation.
sealed class OperationResult {
  const OperationResult();

  /// `true` when the operation was canceled before producing a usable value.
  bool get isCanceled;

  T requireValue<T>() {
    final self = this;
    if (self is OperationSuccess<T>) {
      return self.value;
    }
    throw StateError('Operation was canceled');
  }
}

final class OperationSuccess<T> extends OperationResult {
  final T _value;

  const OperationSuccess(this._value);

  @override
  bool get isCanceled => false;

  T get value => _value;
}

final class OperationCanceled<T> extends OperationResult {
  const OperationCanceled();

  @override
  bool get isCanceled => true;
}

/// Convenience extension for accessing a cubit from a [BuildContext].
extension CubitX<T extends Cubit<dynamic>> on BuildContext {
  T get cubit => BlocProvider.of<T>(this);
}
