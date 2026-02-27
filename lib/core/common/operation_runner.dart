import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

/// Mixin that provides cancellable, latest-only async operation handling.
mixin OperationRunner {
  /// Tracks in-flight async operations keyed by a semantic action name.
  final Map<Object, CancelableOperation<dynamic>> _latestOperations = {};

  /// Runs the latest async operation for [key], canceling any previous one.
  ///
  /// This is useful when only the newest request should win (e.g., search).
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

  /// Cancels any in-flight operations tracked by this runner.
  @protected
  Future<void> cancelLatestOperations() async {
    final operations = _latestOperations.values.toList(growable: false);
    _latestOperations.clear();
    for (final operation in operations) {
      await operation.cancel();
    }
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
