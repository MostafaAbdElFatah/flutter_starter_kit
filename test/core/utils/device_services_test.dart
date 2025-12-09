import 'package:flutter_starter_kit/core/utils/device_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helper/helper_test.mocks.dart';

void main() {
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;
  late MockPlatformChecker mockPlatformChecker;
  late DeviceServices deviceServices;
  setUp(() {
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    mockPlatformChecker = MockPlatformChecker();
    deviceServices = DeviceServices(
      platformChecker: mockPlatformChecker,
      deviceInfoPlugin: mockDeviceInfoPlugin,
    );
  });

  group('DeviceServices', () {
    group('getDeviceModel', () {
      test('returns iOS device model when platform is iOS', () async {
        // Arrange
        final mockIosInfo = MockIosDeviceInfo();
        final mockUtsname = MockIosUtsname();

        when(mockPlatformChecker.isIOS).thenReturn(true);
        when(mockPlatformChecker.isAndroid).thenReturn(false);
        when(mockDeviceInfoPlugin.iosInfo).thenAnswer((_) async => mockIosInfo);
        when(mockIosInfo.utsname).thenReturn(mockUtsname);
        when(mockUtsname.machine).thenReturn('iPhone13,2');

        // Act
        final result = await deviceServices.getDeviceModel();

        // Assert
        expect(result, 'iPhone13,2');
        verify(mockDeviceInfoPlugin.iosInfo).called(1);
        verify(mockIosInfo.utsname).called(1);
        verify(mockUtsname.machine).called(1);
        verify(mockPlatformChecker.isIOS).called(1);
        verifyNever(mockPlatformChecker.isAndroid);
      });

      test('returns Android device model when platform is Android', () async {
        // Arrange
        final mockAndroidInfo = MockAndroidDeviceInfo();

        when(mockPlatformChecker.isIOS).thenReturn(false);
        when(mockPlatformChecker.isAndroid).thenReturn(true);
        when(
          mockDeviceInfoPlugin.androidInfo,
        ).thenAnswer((_) async => mockAndroidInfo);
        when(mockAndroidInfo.device).thenReturn('Pixel 5');

        // Act
        final result = await deviceServices.getDeviceModel();

        // Assert
        expect(result, 'Pixel 5');
        verify(mockDeviceInfoPlugin.androidInfo).called(1);
        verify(mockAndroidInfo.device).called(1);
        verify(mockPlatformChecker.isIOS).called(1);
        verify(mockPlatformChecker.isAndroid).called(1);
        verifyNever(mockDeviceInfoPlugin.iosInfo);
      });

      test('returns null for unsupported platforms', () async {
        // Arrange
        when(mockPlatformChecker.isIOS).thenReturn(false);
        when(mockPlatformChecker.isAndroid).thenReturn(false);

        // Act
        final result = await deviceServices.getDeviceModel();

        // Assert
        expect(result, null);
        verify(mockPlatformChecker.isIOS).called(1);
        verify(mockPlatformChecker.isAndroid).called(1);
        verifyNever(mockDeviceInfoPlugin.iosInfo);
        verifyNever(mockDeviceInfoPlugin.androidInfo);
      });

      test('handles errors when retrieving iOS device info', () async {
        // Arrange
        when(mockPlatformChecker.isIOS).thenReturn(true);
        when(
          mockDeviceInfoPlugin.iosInfo,
        ).thenThrow(Exception('Failed to get iOS info'));

        // Act & Assert
        expect(deviceServices.getDeviceModel(), throwsException);
      });

      test('handles errors when retrieving Android device info', () async {
        // Arrange
        when(mockPlatformChecker.isIOS).thenReturn(false);
        when(mockPlatformChecker.isAndroid).thenReturn(true);
        when(
          mockDeviceInfoPlugin.androidInfo,
        ).thenThrow(Exception('Failed to get Android info'));

        // Act & Assert
        expect(deviceServices.getDeviceModel(), throwsException);
      });
    });
  });
}
