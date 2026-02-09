import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';

class LoginViewState with EquatableMixin {
  final BaseState<String> loginState;

  const LoginViewState(this.loginState);

  factory LoginViewState.init() => LoginViewState(BaseState.init());

  LoginViewState copyWith({BaseState<String>? loginState}) =>
      LoginViewState(loginState ?? this.loginState);

  @override
  List<Object?> get props => [loginState];
}

sealed class LoginViewIntent {}

class DriverLoginIntent extends LoginViewIntent with EquatableMixin {
  final String email;
  final String password;
  final bool rememberMe;

  DriverLoginIntent({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

sealed class LoginViewEvent {}

class LoginNavToHomeEvent extends LoginViewEvent with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class LoginNavToForgetPasswordEvent extends LoginViewEvent with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class LoginFailureEvent extends LoginViewEvent with EquatableMixin {
  final String? errorMessage;

  LoginFailureEvent({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
