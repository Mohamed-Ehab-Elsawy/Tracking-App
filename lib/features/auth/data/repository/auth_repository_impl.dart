import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  @override
  void logout() => AppLocalStorage.clearAll();
}
