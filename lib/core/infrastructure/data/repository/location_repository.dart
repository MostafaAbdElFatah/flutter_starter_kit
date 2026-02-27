// import 'package:injectable/injectable.dart';
//
// import '../../services/location_services.dart';
// import '../entities/location.dart';
//
//
// @LazySingleton(as: LocationRepository)
// class LocationRepositoryImpl implements LocationRepository {
//   @override
//   Future<Location?> getCurrentLocation() async {
//     try {
//       final position = await LocationService.getCurrentLocation();
//       if (position == null) return null;
//       return Location(
//         latitude: position.latitude,
//         longitude: position.longitude,
//       );
//     } catch (_) {
//       return null;
//     }
//   }
// }
