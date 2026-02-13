import 'package:firebase_core/firebase_core.dart';
import 'package:injectable/injectable.dart';

/// Central Firebase bootstrap service.
///
/// This keeps Firebase initialization in one place so feature services
/// (messaging, analytics, crashlytics) can safely call [init] multiple times.
@lazySingleton
class FirebaseService {
  bool _initialized = false;

  bool get isInitialized => _initialized || Firebase.apps.isNotEmpty;

  /// Initializes Firebase once and returns the active [FirebaseApp].
  Future<FirebaseApp> init() async {
    if (_initialized && Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }

    final app = Firebase.apps.isEmpty
        ? await Firebase.initializeApp()
        : Firebase.app();
    _initialized = true;
    return app;
  }
}
