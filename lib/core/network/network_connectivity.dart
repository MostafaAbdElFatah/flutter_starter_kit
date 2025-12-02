import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// An abstract class defining the contract for checking network connectivity.
///
/// This allows for easy mocking and testing of network connectivity logic.
abstract class NetworkConnectivity {
  /// Checks whether the device is connected to the internet.
  ///
  /// Returns `true` if the device is connected to either mobile data or Wi-Fi,
  /// otherwise returns `false`.
  Future<bool> get isConnected;
}

/// A concrete implementation of [NetworkConnectivity] using the [Connectivity] package.
///
/// This class provides the actual logic for checking network connectivity.
@LazySingleton(as: NetworkConnectivity)
class NetworkConnectivityImpl implements NetworkConnectivity {
  final Connectivity _connectivity;

  /// Creates an instance of [NetworkConnectivityImpl].
  ///
  /// - Parameter `connectivity`: An instance of [Connectivity] to check network status.
  NetworkConnectivityImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    // Check the current network connectivity status.
    final connectivityResult = await _connectivity.checkConnectivity();

    // Return `true` if the device is connected to either mobile data or Wi-Fi.
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }
}