import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/repository/profile_repo_impl.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_driver_data.dart';

import 'get_driver_data_test.mocks.dart';

@GenerateMocks([ProfileRepoImpl])
void main() {
  late MockProfileRepoImpl mockProfileRepo;
  late GetDriverDataUseCase useCase;
  late DriverEntity driverEntity;

  setUp(() {
    mockProfileRepo = MockProfileRepoImpl();
    useCase = GetDriverDataUseCase(mockProfileRepo);
    driverEntity = DriverEntity(id: '1', firstName: 'Ahmed');

    provideDummy<Result<DriverEntity>>(Success<DriverEntity>(driverEntity));
  });

  test(
    'should return Success<DriverEntity> when repo returns success',
    () async {
      when(
        mockProfileRepo.getDriverData(),
      ).thenAnswer((_) async => Success(driverEntity));

      final result = await useCase.call();

      expect(result, isA<Success<DriverEntity>>());
      expect((result as Success<DriverEntity>).data, driverEntity);
      verify(mockProfileRepo.getDriverData()).called(1);
    },
  );

  test(
    'should return Failure<DriverEntity> when repo returns failure',
    () async {
      const errorMessage = 'errors.unexpected';
      when(
        mockProfileRepo.getDriverData(),
      ).thenAnswer((_) async => Failure(errorMessage));

      final result = await useCase.call();
      expect(result, isA<Failure<DriverEntity>>());
      expect((result as Failure<DriverEntity>).errorMessage, errorMessage);
      verify(mockProfileRepo.getDriverData()).called(1);
    },
  );
}
