part of 'forget_password_view_model.dart';

class ForgetPasswordState with EquatableMixin {
  final BaseState<EmailVerificationResponseEntity>? emailVerificationState;
  final BaseState<VerificationCodeResponseEntity>? codeVerificationState;
  final BaseState<ResetPasswordResponseEntity>? resetPasswordState;
  final UserEntity? user;

  ForgetPasswordState({
    this.emailVerificationState,
    this.codeVerificationState,
    this.resetPasswordState,
    this.user,
  });

  ForgetPasswordState copyWith({
    BaseState<EmailVerificationResponseEntity>? emailVerificationState,
    BaseState<VerificationCodeResponseEntity>? codeVerificationState,
    BaseState<ResetPasswordResponseEntity>? resetPasswordState,
    UserEntity? user,
  }) {
    return ForgetPasswordState(
      emailVerificationState:
          emailVerificationState ?? this.emailVerificationState,
      codeVerificationState:
          codeVerificationState ?? this.codeVerificationState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    emailVerificationState,
    codeVerificationState,
    resetPasswordState,
    user,
  ];
}

sealed class Intent {}

class EmailVerificationIntent extends Intent {
  final UserEntity user;
  EmailVerificationIntent({required this.user});
}

class CodeVerificationIntent extends Intent {
  final UserEntity user;
  CodeVerificationIntent({required this.user});
}

class ConfirmPasswordIntent extends Intent {
  final UserEntity user;
  ConfirmPasswordIntent({required this.user});
}

class ReSendCodeIntent extends Intent {
  final UserEntity user;
  ReSendCodeIntent({required this.user});
}

//UiEvents
sealed class ForgetPasswordUiEvent {}

//confirmEmail
class ConfirmEmailEvent extends ForgetPasswordUiEvent {}

//sendCode
class SendCodeEvent extends ForgetPasswordUiEvent {}

//resendCode
class ReSendCodeEvent extends ForgetPasswordUiEvent {}

//confirmPassword
class ConfirmPasswordEvent extends ForgetPasswordUiEvent {}

class ShowSnackBarEvent extends ForgetPasswordUiEvent {
  final String message;
  ShowSnackBarEvent(this.message);
}
