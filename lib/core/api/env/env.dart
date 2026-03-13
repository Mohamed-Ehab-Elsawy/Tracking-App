import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'env/.env')
abstract class Env {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _Env.baseUrl;
  @EnviedField(varName: 'MAP_ACCESS_TOKEN', obfuscate: true)
  static final String mapAccessToken = _Env.mapAccessToken;
}
