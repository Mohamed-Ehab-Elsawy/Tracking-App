import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_case/apply_use_case.dart';

import 'apply_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late ApplyUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ApplyUseCase(mockRepository);

    provideDummy<Result<ApplyResponseEntity>>(
      Success(ApplyResponseEntity(message: "", token: "")),
    );
  });

  group('ApplyUseCase Tests', () {
    final tDriverEntity = DriverEntity(firstName: "Ahmed", email: "a@a.com");
    final tNidFile = File('id_path');
    final tLicenseFile = File('license_path');
    final tResponse = ApplyResponseEntity(message: "success", token: "token");

    test('should call apply on repository and return success', () async {
      when(
        mockRepository.apply(
          any,
          nidImage: anyNamed('nidImage'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer((_) async => Success(tResponse));

      final result = await useCase.invoke(
        applyEntity: tDriverEntity,
        nidImage: tNidFile,
        vehicleLicense: tLicenseFile,
      );

      expect(result, isA<Success<ApplyResponseEntity>>());
      expect((result as Success).data, tResponse);
      verify(
        mockRepository.apply(
          tDriverEntity,
          nidImage: tNidFile,
          vehicleLicense: tLicenseFile,
        ),
      ).called(1);
    });

    test('should return failure when repository fails', () async {
      when(
        mockRepository.apply(
          any,
          nidImage: anyNamed('nidImage'),
          vehicleLicense: anyNamed('vehicleLicense'),
        ),
      ).thenAnswer((_) async => Failure("error"));

      final result = await useCase.invoke(
        applyEntity: tDriverEntity,
        nidImage: tNidFile,
        vehicleLicense: tLicenseFile,
      );

      expect(result, isA<Failure<ApplyResponseEntity>>());
      expect((result as Failure).errorMessage, "error");
      verify(
        mockRepository.apply(
          tDriverEntity,
          nidImage: tNidFile,
          vehicleLicense: tLicenseFile,
        ),
      ).called(1);
    });
  });
}
