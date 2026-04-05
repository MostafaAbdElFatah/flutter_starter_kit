import '../../domain/entities/location.dart';

/// Contract for retrieving the device location.
abstract class LocationRepository {
  Future<Location?> getCurrentLocation();
}
