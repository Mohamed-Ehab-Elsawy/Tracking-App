import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
part 'forget_password_state.dart';

@lazySingleton
class ForgetPasswordViewModel
    extends BaseCubit<ForgetPasswordState, Intent, ForgetPasswordUiEvent> {
  ForgetPasswordViewModel(this._authRepository)
    : super(
        ForgetPasswordState(
          emailVerificationState: BaseState.init(),
          codeVerificationState: BaseState.init(),
          resetPasswordState: BaseState.init(),
          user: UserEntity(),
        ),
      );

  final AuthRepository _authRepository;

  @override
  Future<void> doIntent(intent) async {
    switch (intent) {
      case CodeVerificationIntent():
        _codeVerification(intent.user);
      case ConfirmPasswordIntent():
        _confirmPassword(intent.user);
      case EmailVerificationIntent():
        _emailVerification(intent.user);
      case ReSendCodeIntent():
        _resendCode(intent.user);
    }
  }

  void _emailVerification(UserEntity user) async {
    emit(state.copyWith(emailVerificationState: BaseState.loading()));
    final response = await _authRepository.sendResetPasswordCode(user);
    switch (response) {
      case Success<EmailVerificationResponseEntity>():
        emit(
          state.copyWith(
            emailVerificationState: BaseState.loaded(response.data),
            user: user,
          ),
        );
        log("Success");
        emitEvent(ConfirmEmailEvent());

      case Failure<EmailVerificationResponseEntity>():
        emit(
          state.copyWith(
            emailVerificationState: BaseState.error(response.errorMessage),
          ),
        );
        emitEvent(ShowSnackBarEvent(response.errorMessage));
        log("failure");
    }
  }

  void _resendCode(UserEntity user) async {
    emit(state.copyWith(emailVerificationState: BaseState.loading()));
    final response = await _authRepository.sendResetPasswordCode(user);
    switch (response) {
      case Success<EmailVerificationResponseEntity>():
        emit(
          state.copyWith(
            emailVerificationState: BaseState.loaded(response.data),
            user: user,
          ),
        );
        log("Success");
        emitEvent(ReSendCodeEvent());

      case Failure<EmailVerificationResponseEntity>():
        emit(
          state.copyWith(
            emailVerificationState: BaseState.error(response.errorMessage),
          ),
        );
        emitEvent(ShowSnackBarEvent(response.errorMessage));
        log("failure");
    }
  }

  void _codeVerification(UserEntity user) async {
    emit(state.copyWith(codeVerificationState: BaseState.loading()));
    final response = await _authRepository.verifyResetPasswordCode(user);
    switch (response) {
      case Success<VerificationCodeResponseEntity>():
        emit(
          state.copyWith(
            codeVerificationState: BaseState.loaded(response.data),
          ),
        );
        log("Success");
        emitEvent(SendCodeEvent());

      case Failure<VerificationCodeResponseEntity>():
        emit(
          state.copyWith(
            codeVerificationState: BaseState.error(response.errorMessage),
          ),
        );
        emitEvent(ShowSnackBarEvent(response.errorMessage));
        log("failure");
    }
  }

  void _confirmPassword(UserEntity user) async {
    emit(state.copyWith(resetPasswordState: BaseState.loading()));
    final response = await _authRepository.resetPassword(user);
    switch (response) {
      case Success<ResetPasswordResponseEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState.loaded(response.data),
            user: user,
          ),
        );
        log("Success");
        emitEvent(ConfirmPasswordEvent());

      case Failure<ResetPasswordResponseEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState.error(response.errorMessage),
          ),
        );
        emitEvent(ShowSnackBarEvent(response.errorMessage));
        log("failure");
    }
  }
}
