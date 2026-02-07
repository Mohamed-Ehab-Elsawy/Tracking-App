import 'package:tracking_app/core/error_handling/result.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<String>> login(String email, String password);
}
