import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);

    provideDummy<Result<ApplyResponse>>(Success(ApplyResponse()));
    provideDummy<Result<GetAllVehiclesResponse>>(
      Success(GetAllVehiclesResponse()),
    );
  });

  group('getAllVehicles', () {
    test(
      'should return Success<List<VehicleEntity>> when dataSource returns success',
      () async {
        final tVehiclesModel = [Vehicles(id: "1", type: "Car")];
        final tResponse = GetAllVehiclesResponse(vehicles: tVehiclesModel);

        when(
          mockDataSource.getAllVehicles(),
        ).thenAnswer((_) async => Success(tResponse));

        final result = await repository.getAllVehicles();

        expect(result, isA<Success<List<VehicleEntity>>>());
        expect((result as Success).data.first.id, "1");
      },
    );

    test('should return Failure when dataSource returns failure', () async {
      when(
        mockDataSource.getAllVehicles(),
      ).thenAnswer((_) async => Failure("error_msg"));

      final result = await repository.getAllVehicles();

      expect(result, isA<Failure<List<VehicleEntity>>>());
      expect((result as Failure).errorMessage, "error_msg");
    });
  });

  group('apply', () {
    final tDriverEntity = DriverEntity(firstName: "Ahmed", email: "a@a.com");
    final tFile = File('dummy');

    test(
      'should return Success<ApplyResponseEntity> when dataSource returns success',
      () async {
        final tApplyResponse = ApplyResponse(
          message: "success",
          token: "token123",
        );

        when(
          mockDataSource.apply(
            any,
            nidImage: anyNamed('nidImage'),
            vehicleLicense: anyNamed('vehicleLicense'),
          ),
        ).thenAnswer((_) async => Success(tApplyResponse));

        final result = await repository.apply(
          tDriverEntity,
          nidImage: tFile,
          vehicleLicense: tFile,
        );

        expect(result, isA<Success<ApplyResponseEntity>>());
        expect((result as Success).data.token, "token123");
      },
    );

    test('should return Failure when dataSource returns failure', () async {
      when(
        mockDataSource.apply(
          any,
          nidImage: anyNamed('nidImage'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer((_) async => Failure("server_error"));

      final result = await repository.apply(
        tDriverEntity,
        nidImage: tFile,
        vehicleLicense: tFile,
      );

      expect(result, isA<Failure<ApplyResponseEntity>>());
      expect((result as Failure).errorMessage, "server_error");
    });
  });
}
