import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class ChangePasswordUseCase {
  final AuthRepository _authRepository;
  const ChangePasswordUseCase(this._authRepository);

  Future<Result<ChangePasswordResponse>> call({
    required String password,
    required String newPassword,
  }) {
    return _authRepository.changePassword(
      password: password,
      newPassword: newPassword,
    );
  }
}
