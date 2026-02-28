import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/use_case/driver_login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';

@injectable
class LoginCubit
    extends BaseCubit<LoginViewState, LoginViewIntent, LoginViewEvent> {
  final DriverLoginUseCase _driverLoginUseCase;

  LoginCubit(this._driverLoginUseCase) : super(LoginViewState.init());

  @override
  Future<void> doIntent(LoginViewIntent intent) async {
    switch (intent) {
      case DriverLoginIntent():
        _login(intent.email, intent.password, intent.rememberMe);
    }
  }

  _login(String email, String password, bool rememberMe) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    var result = await _driverLoginUseCase.call(email, password, rememberMe);
    switch (result) {
      case Success<String>():
        emit(state.copyWith(loginState: BaseState.loaded(result.data)));
        emitEvent(LoginNavToHomeEvent());
      case Failure<String>():
        emit(state.copyWith(loginState: BaseState.error(result.errorMessage)));
        emitEvent(LoginFailureEvent(errorMessage: result.errorMessage));
    }
  }
}
