import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {}
