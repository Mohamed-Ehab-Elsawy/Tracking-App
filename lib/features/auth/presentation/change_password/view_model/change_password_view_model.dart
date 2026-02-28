import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/domain/use_cases/change_password_use_case/change_password_use_case.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_intent.dart';
part 'change_password_state.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;
  ChangePasswordViewModel(this._changePasswordUseCase)
    : super(ChangePasswordState.initial());
  final _uiEventsController =
      StreamController<ChangePasswordUiIntent>.broadcast();
  Stream<ChangePasswordUiIntent> get uiEventsStream =>
      _uiEventsController.stream;

  void doIntent(Intent intent) {
    switch (intent) {
      case ChangePasswordIntent():
        _changePassword(
          password: intent.password,
          newPassword: intent.newPassword,
        );
    }
  }

  Future<void> _changePassword({
    required String password,
    required String newPassword,
  }) async {
    emit(
      state.copyWith(changePasswordState: state.changePasswordState.loading),
    );
    var response = await _changePasswordUseCase.call(
      password: password,
      newPassword: newPassword,
    );
    switch (response) {
      case Success<ChangePasswordResponse>():
        emit(
          state.copyWith(
            changePasswordState: state.changePasswordState.loaded(
              response.data,
            ),
          ),
        );
        _uiEventsController.add(
          ChangePasswordShowToast(message: response.data.message ?? ""),
        );
        _uiEventsController.add(PopScreenIntent());
      case Failure<ChangePasswordResponse>():
        emit(
          state.copyWith(
            changePasswordState: state.changePasswordState.error(
              response.errorMessage,
            ),
          ),
        );
        _uiEventsController.add(
          ChangePasswordShowToast(
            message: response.errorMessage,
            isError: true,
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _uiEventsController.close();
    return super.close();
  }
}
