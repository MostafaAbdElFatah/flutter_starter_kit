import 'dart:async';
import 'dart:collection';

import 'package:injectable/injectable.dart';

enum OpenMode {
  /// If a dialog is already open, do nothing and return null.
  drops,

  /// Queue this dialog and show it after the current one closes.
  defers,

  /// Show this dialog above the current one.
  stacks,

  /// Close the current dialog first, then open the new one.
  replaces,
}

typedef CloseActiveModal = Future<void> Function();

@lazySingleton
class DialogGuard {
  final List<CloseActiveModal> _activeClosers = <CloseActiveModal>[];
  final Queue<Future<void> Function()> _deferredQueue =
  Queue<Future<void> Function()>();
  bool _isDrainPaused = false;

  bool get canShow => _activeClosers.isEmpty;

  bool get hasVisibleModal => _activeClosers.isNotEmpty;

  Future<T?> show<T>({
    OpenMode mode = OpenMode.drops,
    required Future<T?> Function() open,
    required CloseActiveModal closeActive,
  }) async {
    switch (mode) {
      case OpenMode.drops:
        if (hasVisibleModal) return null;
        return _track(open: open, closeActive: closeActive);
      case OpenMode.defers:
        if (!hasVisibleModal) {
          return _track(open: open, closeActive: closeActive);
        }
        final completer = Completer<T?>();
        _deferredQueue.add(
              () async {
            if (completer.isCompleted) return;
            try {
              completer.complete(
                await _track(open: open, closeActive: closeActive),
              );
            } catch (error, stackTrace) {
              completer.completeError(error, stackTrace);
            }
          },
        );
        return completer.future;
      case OpenMode.stacks:
        return _track(open: open, closeActive: closeActive);
      case OpenMode.replaces:
        final hasActiveModal = hasVisibleModal;
        _isDrainPaused = true;
        try {
          await _closeTop();
          if (hasActiveModal) {
            await Future<void>.delayed(const Duration(milliseconds: 150));
          }
          return _track(open: open, closeActive: closeActive);
        } finally {
          _isDrainPaused = false;
          _drainQueue();
        }
    }
  }

  Future<T?> _track<T>({
    required Future<T?> Function() open,
    required CloseActiveModal closeActive,
  }) {
    _activeClosers.add(closeActive);
    try {
      return open().whenComplete(() {
        _removeCloser(closeActive);
        _drainQueue();
      });
    } catch (_) {
      _removeCloser(closeActive);
      _drainQueue();
      rethrow;
    }
  }

  Future<void> _closeTop() async {
    if (!hasVisibleModal) return;
    await _activeClosers.last.call();
  }

  void _removeCloser(CloseActiveModal closeActive) {
    final index = _activeClosers.lastIndexOf(closeActive);
    if (index == -1) return;
    _activeClosers.removeAt(index);
  }

  void _drainQueue() {
    if (_isDrainPaused || hasVisibleModal || _deferredQueue.isEmpty) return;
    unawaited(_deferredQueue.removeFirst().call());
  }
}
