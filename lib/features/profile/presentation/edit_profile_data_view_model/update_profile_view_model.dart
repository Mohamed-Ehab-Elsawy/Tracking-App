import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_driver_data.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_states.dart';

@injectable
// ignore: must_be_immutable
class UpdateProfileViewModel extends Cubit<UpdateProfileStates>
    with EquatableMixin {
  final UpdateDriverDataUseCase _updateDriverDataUseCase;
  UpdateProfileViewModel(this._updateDriverDataUseCase)
    : super(UpdateProfileStates());
  @override
  List<Object> get props {
    return [state];
  }

  final StreamController<UpdateProfileUiEvents> _uiController =
      StreamController.broadcast();

  Stream<UpdateProfileUiEvents> get uiEvents => _uiController.stream;

  void doEvent(UpdateProfileUiEvents event) {
    switch (event) {
      case NavigateToResetPassword():
        _uiController.add(NavigateToResetPassword());
      case ShowToast():
        _uiController.add(
          ShowToast(message: event.message, isError: event.isError),
        );
    }
  }

  void doIntent(UpdateProfileEvents event) {
    switch (event) {
      case UpdateDataEvent():
        _updateDriverData(editProfileRequest: event.updateProfileRequest);
    }
  }

  Future<void> _updateDriverData({
    required UpdateProfileRequest editProfileRequest,
  }) async {
    emit(
      state.copyWith(
        ubdateDriverData: BaseState(requestState: RequestState.loading),
      ),
    );
    final Result<DriverEntity> result = await _updateDriverDataUseCase.call(
      editProfileRequest: editProfileRequest,
    );
    switch (result) {
      case Success<DriverEntity>():
        {
          emit(
            state.copyWith(
              ubdateDriverData: BaseState(
                requestState: RequestState.loaded,
                data: result.data,
              ),
            ),
          );
        }

      case Failure<DriverEntity>():
        {
          emit(
            state.copyWith(
              ubdateDriverData: BaseState(
                requestState: RequestState.error,
                errorMessage: result.errorMessage,
              ),
            ),
          );
        }
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
