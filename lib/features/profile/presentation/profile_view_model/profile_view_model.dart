import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_states.dart';

@injectable
// ignore: must_be_immutable
class ProfileViewModel extends Cubit<ProfileStates> with EquatableMixin {
  final GetDriverDataUseCase _getDriverDataUseCase;
  ProfileViewModel(this._getDriverDataUseCase) : super(ProfileStates());
  @override
  List<Object> get props {
    return [state];
  }

  final _uiController = StreamController<ProfileUiEvents>.broadcast();

  Stream<ProfileUiEvents> get uiEvents => _uiController.stream;

  void doEvent(ProfileUiEvents event) {
    switch (event) {
      case OnLanguageClickIntent():
        _uiController.add(OnLanguageClickIntent());
      case OnLogoutClickIntent():
        _uiController.add(OnLogoutClickIntent());
      case OnProfileClickIntent():
        _uiController.add(OnProfileClickIntent());
      case OnVehicleInfoClickIntent():
        _uiController.add(OnVehicleInfoClickIntent());

      case NavigateToNotification():
        _uiController.add(NavigateToNotification());
    }
  }

  void doIntent(ProfileEvents event) {
    switch (event) {
      case GetDriverDataEvent():
        _getDriverData();
    }
  }

  Future<void> _getDriverData() async {
    emit(
      state.copyWith(driverData: BaseState(requestState: RequestState.loading)),
    );
    final Result<DriverEntity> result = await _getDriverDataUseCase.call();
    switch (result) {
      case Success<DriverEntity>():
        {
          emit(
            state.copyWith(
              driverData: BaseState(
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
              driverData: BaseState(
                requestState: RequestState.error,
                errorMessage: result.errorMessage,
              ),
            ),
          );
        }
    }
  }
}
