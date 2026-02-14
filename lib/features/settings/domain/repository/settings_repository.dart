/// An abstract repository that defines the contract for settings-related operations.
abstract class SettingsRepository {
  Future<void> saveFirebaseToken(String token);
}
