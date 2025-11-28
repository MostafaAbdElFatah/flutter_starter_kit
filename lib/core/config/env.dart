import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev', name: 'EnvDev')
abstract class EnvDev {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvDev.baseUrl;
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _EnvDev.apiKey;
}

@Envied(path: '.env.prod', name: 'EnvProd')
abstract class EnvProd {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvProd.baseUrl;
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _EnvProd.apiKey;
}

@Envied(path: '.env.stage', name: 'EnvStage')
abstract class EnvStage {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvStage.baseUrl;
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _EnvStage.apiKey;
}

@Envied(path: '.env.test', name: 'EnvTest')
abstract class EnvTest {
  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _EnvTest.baseUrl;
  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _EnvTest.apiKey;
}
