import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';

class LoginViewState with EquatableMixin {
  final BaseState<String> state;

  const LoginViewState(this.state);

  factory LoginViewState.init() => LoginViewState(BaseState.init());

  LoginViewState copyWith(BaseState<String>? state) =>
      LoginViewState(state ?? this.state);

  @override
  List<Object?> get props => [state];
}

sealed class LoginViewEvent {}

class DriverLoginEvent extends LoginViewEvent {
  final String email;
  final String password;
  final bool rememberMe;

  DriverLoginEvent({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

sealed class LoginViewNavigationEvent {}

class LoginNavToHomeEvent extends LoginViewNavigationEvent {}

class LoginPopEvent extends LoginViewNavigationEvent {}

class LoginNavToForgetPasswordEvent extends LoginViewNavigationEvent {}
