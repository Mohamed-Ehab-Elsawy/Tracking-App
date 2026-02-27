import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class DriverLoginUseCase {
  final AuthRepository _authRepository;

  DriverLoginUseCase(this._authRepository);

  Future<Result<String>> call(String email, String password, bool rememberMe) =>
      _authRepository.login(email, password, rememberMe);
}
