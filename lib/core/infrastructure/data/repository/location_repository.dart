// import 'package:injectable/injectable.dart';
//
// import '../../domain/entities/location.dart';
// import '../../../services/location_services.dart';
// import '../../domain/repository/location_repository.dart';
//
// @LazySingleton(as: LocationRepository)
// class LocationRepositoryImpl implements LocationRepository {
//   static const Duration _locationTimeout = Duration(seconds: 1);
//   Future<Location?>? _inFlightLocationRequest;
//
//   @override
//   Future<Location?> getCurrentLocation() {
//     final inFlight = _inFlightLocationRequest;
//     if (inFlight != null) return inFlight;
//
//     final request = _resolveCurrentLocation();
//     _inFlightLocationRequest = request;
//     return request.whenComplete(() {
//       if (identical(_inFlightLocationRequest, request)) {
//         _inFlightLocationRequest = null;
//       }
//     });
//   }
//
//   Future<Location?> _resolveCurrentLocation() async {
//     try {
//       final position = await LocationService.getCurrentLocation().timeout(
//         _locationTimeout,
//         onTimeout: LocationService.getLastKnownPosition,
//       );
//       if (position == null) return null;
//       return Location(
//         latitude: position.latitude,
//         longitude: position.longitude,
//       );
//     } catch (_) {
//       try {
//         final position = await LocationService.getLastKnownPosition();
//         if (position == null) return null;
//         return Location(
//           latitude: position.latitude,
//           longitude: position.longitude,
//         );
//       } catch (_) {
//         return null;
//       }
//     }
//   }
// }
