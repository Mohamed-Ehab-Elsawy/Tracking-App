import 'package:tracking_app/core/error_handling/result.dart';

abstract interface class AuthRepository {
  Future<Result<String>> login(String email, String password, bool rememberMe);
}
