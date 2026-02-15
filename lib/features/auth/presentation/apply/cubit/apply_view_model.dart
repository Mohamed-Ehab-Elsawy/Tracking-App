import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/features/auth/domain/use_case/apply_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_case/get_vehicles_use_case.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';

@injectable
class ApplyViewModel extends BaseCubit<ApplyState, ApplyIntent, ApplyEvent> {
  final ApplyUseCase _applyUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;
  ApplyViewModel(this._applyUseCase, this._getVehiclesUseCase)
    : super(ApplyState.initial());

  @override
  Future<void> doIntent(ApplyIntent event) {
    switch (event) {
      case GetVehiclesIntent():
        return _getVehicles();
      case SubmitApplyIntent():
        return _submitApply(event);
      case UploadImageIntent():
        _handleImageSelection(event.image, event.isNid);
        return Future.value();
      case ChoseImageFromGalleryIntent():
        _handleImageSelection(event.image, event.isNid);
        return Future.value();
      case SelectGender():
        _selectGander(event.gender);
        return Future.value();
    }
  }

  void _handleImageSelection(File? file, bool isNid) {
    if (isNid) {
      emit(state.copyWith(nidImage: file));
    } else {
      emit(state.copyWith(vehicleLicense: file));
    }
  }

  Future<void> _getVehicles() async {
    emit(state.copyWith(vehicleState: BaseState.loading()));
    final result = await _getVehiclesUseCase.invoke();
    switch (result) {
      case Success<List<VehicleEntity>>():
        emit(state.copyWith(vehicleState: BaseState.loaded(result.data)));
      case Failure<List<VehicleEntity>>():
        emit(
          state.copyWith(vehicleState: BaseState.error(result.errorMessage)),
        );
        doNavigationAction(
          ShowSnackBarEvent(message: result.errorMessage, isError: true),
        );
    }
  }

  Future<void> _submitApply(SubmitApplyIntent event) async {
    final nidFile = event.driverEntity.nidImage ?? state.nidImage;
    final licenseFile =
        event.driverEntity.vehicleLicense ?? state.vehicleLicense;

    if (nidFile == null || licenseFile == null) {
      doNavigationAction(
        ShowSnackBarEvent(message: 'image_required'.tr(), isError: true),
      );
      return;
    }

    emit(state.copyWith(applyState: BaseState.loading()));

    final result = await _applyUseCase.invoke(
      applyEntity: event.driverEntity,
      nidImage: nidFile,
      vehicleLicense: licenseFile,
    );

    switch (result) {
      case Success<ApplyResponseEntity>():
        emit(state.copyWith(applyState: BaseState.loaded(result.data)));
        doNavigationAction(
          ShowSnackBarEvent(
            message: result.data.message ?? 'success'.tr(),
            isError: false,
          ),
        );
        doNavigationAction(NavigateSuccessApplyIntent());
      case Failure<ApplyResponseEntity>():
        emit(state.copyWith(applyState: BaseState.error(result.errorMessage)));
        doNavigationAction(
          ShowSnackBarEvent(message: result.errorMessage, isError: true),
        );
    }
  }

  void _selectGander(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
