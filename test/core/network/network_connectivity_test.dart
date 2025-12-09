import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import 'package:flutter_starter_kit/core/infrastructure/data/network/network_connectivity.dart';
import '../core_mocks_test.mocks.dart';


void main() {
  late MockConnectivity mockConnectivity;
  late NetworkConnectivityImpl connectivityService;

  setUp(() {
    mockConnectivity = MockConnectivity();
    connectivityService = NetworkConnectivityImpl(mockConnectivity);
  });

  test('returns true when connected to mobile data', () async {
    // Arrange
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.mobile]);

    // Act
    final result = await connectivityService.isConnected;

    // Assert
    expect(result, true);
  });

  test('returns true when connected to wifi', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);

    final result = await connectivityService.isConnected;

    expect(result, true);
  });

  test('returns true when connected to wifi and mobile data', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile]);

    final result = await connectivityService.isConnected;

    expect(result, true);
  });


  test('returns false when there is no network', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.none]);

    final result = await connectivityService.isConnected;

    expect(result, false);
  });
}
