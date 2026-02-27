import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_states.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'profile_view_model_test.mocks.dart';

@GenerateMocks([GetDriverDataUseCase])
void main() {
  late MockGetDriverDataUseCase useCase;
  late DriverEntity entity;
  setUp(() {
    useCase = MockGetDriverDataUseCase();
    entity = DriverEntity(firstName: "s", lastName: "s");
    provideDummy<Result<DriverEntity>>(Success<DriverEntity>(entity));
  });
  blocTest<ProfileViewModel, ProfileStates>(
    'emits [loading, success] when _getDriverData returns Success',
    build: () {
      when(
        useCase.call(),
      ).thenAnswer((_) async => Success<DriverEntity>(entity));
      return ProfileViewModel(useCase);
    },
    act: (cubit) => cubit.doIntent(GetDriverDataEvent()),
    expect: () {
      var state = const ProfileStates(
        driverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          driverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          driverData: BaseState<DriverEntity>(
            data: entity,
            requestState: RequestState.loaded,
          ),
        ),
      ];
    },
  );
  blocTest<ProfileViewModel, ProfileStates>(
    'emits [loading, failure] when _getDriverData returns Failure',
    build: () {
      when(
        useCase.call(),
      ).thenAnswer((_) async => Failure<DriverEntity>("error"));
      return ProfileViewModel(useCase);
    },
    act: (cubit) => cubit.doIntent(GetDriverDataEvent()),
    expect: () {
      var state = const ProfileStates(
        driverData: BaseState(requestState: RequestState.loading),
      );
      return [
        state.copyWith(
          driverData: const BaseState<DriverEntity>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          driverData: BaseState<DriverEntity>(
            errorMessage: "error",
            requestState: RequestState.error,
          ),
        ),
      ];
    },
  );
}
