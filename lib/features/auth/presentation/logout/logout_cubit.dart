import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class LogoutCubit extends Cubit<LogoutDialogState> {
  final AuthRepository _authRepository;

  LogoutCubit(this._authRepository) : super(LogoutDialogState());

  void doIntent(LogoutDialogIntent intent) {
    switch (intent) {
      case DriverLogoutIntent():
        _logout();
    }
  }

  void _logout() => _authRepository.logout();
}

sealed class LogoutDialogIntent {}

final class DriverLogoutIntent extends LogoutDialogIntent {}

class LogoutDialogState {}
