import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/features/auth/domain/use_case/apply_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_case/get_vehicles_use_case.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';

import 'apply_view_model_test.mocks.dart';

@GenerateMocks([ApplyUseCase, GetVehiclesUseCase])
void main() {
  late MockApplyUseCase mockApplyUseCase;
  late MockGetVehiclesUseCase mockGetVehiclesUseCase;
  late ApplyViewModel viewModel;

  setUp(() {
    mockApplyUseCase = MockApplyUseCase();
    mockGetVehiclesUseCase = MockGetVehiclesUseCase();
    viewModel = ApplyViewModel(mockApplyUseCase, mockGetVehiclesUseCase);

    provideDummy<Result<List<VehicleEntity>>>(Success([]));
    provideDummy<Result<ApplyResponseEntity>>(
      Success(ApplyResponseEntity(message: "", token: "")),
    );
  });

  group('GetVehicles Cases', () {
    final tVehicles = [VehicleEntity(id: "1", type: "Truck")];

    blocTest<ApplyViewModel, ApplyState>(
      'emit [loading, loaded] when getVehicles succeeds',
      build: () {
        when(
          mockGetVehiclesUseCase.invoke(),
        ).thenAnswer((_) async => Success(tVehicles));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetVehiclesIntent()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleState.toString().toLowerCase(),
          'state',
          contains('loading'),
        ),
        isA<ApplyState>().having(
          (s) => s.vehicleState.toString().toLowerCase(),
          'state',
          contains('loaded'),
        ),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emit [loading, error] when getVehicles fails',
      build: () {
        when(
          mockGetVehiclesUseCase.invoke(),
        ).thenAnswer((_) async => Failure("network error"));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(GetVehiclesIntent()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleState.toString().toLowerCase(),
          'state',
          contains('loading'),
        ),
        isA<ApplyState>().having(
          (s) => s.vehicleState.toString().toLowerCase(),
          'state',
          contains('error'),
        ),
      ],
    );
  });

  group('SubmitApply Cases', () {
    final tDriver = DriverEntity(firstName: "Abdelrahman");
    final tFile = File('dummy_path');
    final tResponse = ApplyResponseEntity(
      message: "Success",
      token: "valid_token",
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emit [loading, loaded] when submit succeeds with images provided',
      build: () {
        viewModel.emit(
          viewModel.state.copyWith(nidImage: tFile, vehicleLicense: tFile),
        );
        when(
          mockApplyUseCase.invoke(
            applyEntity: anyNamed('applyEntity'),
            nidImage: anyNamed('nidImage'),
            vehicleLicense: anyNamed('vehicleLicense'),
          ),
        ).thenAnswer((_) async => Success(tResponse));
        return viewModel;
      },
      act: (bloc) => bloc.doIntent(SubmitApplyIntent(driverEntity: tDriver)),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.toString().toLowerCase(),
          'state',
          contains('loading'),
        ),
        isA<ApplyState>().having(
          (s) => s.applyState.toString().toLowerCase(),
          'state',
          contains('loaded'),
        ),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'not emit any state when images are missing',
      build: () => viewModel,
      act: (bloc) => bloc.doIntent(SubmitApplyIntent(driverEntity: tDriver)),
      expect: () => [],
    );
  });

  group('Selection & UI Logic', () {
    final tFile = File('test_image.png');

    blocTest<ApplyViewModel, ApplyState>(
      'update nidImage in state when UploadImageIntent is called',
      build: () => viewModel,
      act: (bloc) =>
          bloc.doIntent(UploadImageIntent(image: tFile, isNid: true)),
      expect: () => [
        isA<ApplyState>().having((s) => s.nidImage, 'nidImage', tFile),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'update vehicleLicense in state when ChoseImageFromGalleryIntent is called',
      build: () => viewModel,
      act: (bloc) => bloc.doIntent(
        ChoseImageFromGalleryIntent(image: tFile, isNid: false),
      ),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleLicense,
          'vehicleLicense',
          tFile,
        ),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'update selectedGender when SelectGender is called',
      build: () => viewModel,
      act: (bloc) => bloc.doIntent(SelectGender("female")),
      expect: () => [
        isA<ApplyState>().having((s) => s.selectedGender, 'gender', "female"),
      ],
    );
  });
}
