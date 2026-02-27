import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_case/get_vehicles_use_case.dart';

import 'get_vehicles_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockRepository;
  late GetVehiclesUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetVehiclesUseCase(mockRepository);

    provideDummy<Result<List<VehicleEntity>>>(Success([]));
  });

  group('GetVehiclesUseCase Tests', () {
    final tVehicles = [VehicleEntity(id: "1", type: "Car")];

    test(
      'should return Success<List<VehicleEntity>> when repository succeeds',
      () async {
        // Arrange
        when(
          mockRepository.getAllVehicles(),
        ).thenAnswer((_) async => Success(tVehicles));

        // Act
        final result = await useCase.invoke();

        // Assert
        expect(result, isA<Success<List<VehicleEntity>>>());
        expect((result as Success).data, tVehicles);
        verify(mockRepository.getAllVehicles()).called(1);
      },
    );

    test('should return Failure when repository fails', () async {
      // Arrange
      when(
        mockRepository.getAllVehicles(),
      ).thenAnswer((_) async => Failure("error"));

      // Act
      final result = await useCase.invoke();

      // Assert
      expect(result, isA<Failure<List<VehicleEntity>>>());
      expect((result as Failure).errorMessage, "error");
      verify(mockRepository.getAllVehicles()).called(1);
    });
  });
}
