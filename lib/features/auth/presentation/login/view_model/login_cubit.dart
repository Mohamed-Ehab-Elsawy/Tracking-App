import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/use_case/driver_login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';

@injectable
class LoginCubit
    extends
        BaseCubit<LoginViewState, LoginViewEvent, LoginViewNavigationEvent> {
  final DriverLoginUseCase _driverLoginUseCase;

  LoginCubit(this._driverLoginUseCase) : super(LoginViewState.init());

  @override
  Future<void> doAction(LoginViewEvent event) async {
    switch (event) {
      case DriverLoginEvent():
        _login(event.email, event.password, event.rememberMe);
    }
  }

  _login(String email, String password, bool rememberMe) async {
    emit(state.copyWith(BaseState.loading()));
    var result = await _driverLoginUseCase.call(email, password, rememberMe);
    switch (result) {
      case Success<String>():
        emit(state.copyWith(BaseState.loaded(result.data)));
        doNavigationAction(LoginNavToHomeEvent());
      case Failure<String>():
        emit(state.copyWith(BaseState.error(result.errorMessage)));
    }
  }
}
