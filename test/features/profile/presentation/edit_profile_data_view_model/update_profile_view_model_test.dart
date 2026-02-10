import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_driver_data.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_states.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'update_profile_view_model_test.mocks.dart';

@GenerateMocks([UpdateDriverDataUseCase])
void main() {
  late MockUpdateDriverDataUseCase useCase;
  late DriverEntity entity;
  late UpdateProfileRequest updateProfileRequest;
  setUp(() {
    useCase = MockUpdateDriverDataUseCase();
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
      return UpdateProfileViewModel(useCase);
    },
    act: (cubit) => cubit.doIntent(UpdateDataEvent(updateProfileRequest)),

    expect: () {
      var state = const UpdateProfileStates(
        ubdateDriverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          ubdateDriverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          ubdateDriverData: BaseState<DriverEntity>(
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
      return UpdateProfileViewModel(useCase);
    },
    act: (cubit) => cubit.doIntent(UpdateDataEvent(updateProfileRequest)),
    expect: () {
      var state = const UpdateProfileStates(
        ubdateDriverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          ubdateDriverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          ubdateDriverData: BaseState<DriverEntity>(
            errorMessage: "error",
            requestState: RequestState.error,
          ),
        ),
      ];
    },
  );
}
