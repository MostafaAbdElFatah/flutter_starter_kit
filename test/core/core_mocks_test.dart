import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'package:flutter_starter_kit/core/infrastructure/data/storage/secure_storage_service.dart';

@GenerateMocks([
  Dio,
  Connectivity,
  FlutterSecureStorage,


  SecureStorageService,
])
void main() {}