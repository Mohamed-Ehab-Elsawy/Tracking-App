import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';

abstract interface class AuthRepository {
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}
