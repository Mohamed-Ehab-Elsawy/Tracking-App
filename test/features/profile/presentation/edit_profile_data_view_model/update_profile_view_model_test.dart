import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_driver_data.dart';
import 'package:tracking_app/features/profile/domain/use_cases/upload_photo_use_case.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_states.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'update_profile_view_model_test.mocks.dart';

@GenerateMocks([UpdateDriverDataUseCase, UploadPhotoUseCase])
void main() {
  late MockUpdateDriverDataUseCase useCase;
  late DriverEntity entity;
  late UpdateProfileRequest updateProfileRequest;
  late MockUploadPhotoUseCase useCase2;

  setUp(() {
    useCase = MockUpdateDriverDataUseCase();
    useCase2 = MockUploadPhotoUseCase();
    entity = DriverEntity(firstName: "s", lastName: "s");
    updateProfileRequest = UpdateProfileRequest(firstName: "s", lastName: "s");

    provideDummy<Result<DriverEntity>>(Success<DriverEntity>(entity));
  });
  blocTest<UpdateProfileViewModel, UpdateProfileStates>(
    'emits [loading, success] when _updateDriverData returns Success',
    build: () {
      when(
        useCase.call(editProfileRequest: updateProfileRequest),
      ).thenAnswer((_) async => Success<DriverEntity>(entity));
      return UpdateProfileViewModel(useCase, useCase2);
    },
    act: (cubit) => cubit.doIntent(UpdateDataEvent(updateProfileRequest)),

    expect: () {
      var state = const UpdateProfileStates(
        updateDriverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          updateDriverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          updateDriverData: BaseState<DriverEntity>(
            data: entity,
            requestState: RequestState.loaded,
          ),
        ),
      ];
    },
  );
  blocTest<UpdateProfileViewModel, UpdateProfileStates>(
    'emits [loading, failure] when _updateDriverData returns Failure',
    build: () {
      when(
        useCase.call(editProfileRequest: updateProfileRequest),
      ).thenAnswer((_) async => Failure<DriverEntity>("error"));
      return UpdateProfileViewModel(useCase, useCase2);
    },
    act: (cubit) => cubit.doIntent(UpdateDataEvent(updateProfileRequest)),
    expect: () {
      var state = const UpdateProfileStates(
        updateDriverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          updateDriverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          updateDriverData: BaseState<DriverEntity>(
            errorMessage: "error",
            requestState: RequestState.error,
          ),
        ),
      ];
    },
  );
}
