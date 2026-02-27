import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/repository/profile_repo_impl.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_driver_data.dart';

import 'get_driver_data_test.mocks.dart';

@GenerateMocks([ProfileRepoImpl])
void main() {
  late MockProfileRepoImpl mockProfileRepo;
  late UpdateDriverDataUseCase useCase;
  late DriverEntity driverEntity;
  late UpdateProfileRequest updateProfileRequest;
  setUp(() {
    mockProfileRepo = MockProfileRepoImpl();
    useCase = UpdateDriverDataUseCase(mockProfileRepo);
    driverEntity = DriverEntity(id: '1', firstName: 'Ahmed');
    updateProfileRequest = UpdateProfileRequest(firstName: "s", lastName: "s");
    provideDummy<Result<DriverEntity>>(Success<DriverEntity>(driverEntity));
  });

  test(
    'should return Success<DriverEntity> when repo returns success',
    () async {
      when(
        mockProfileRepo.updateProfileData(
          editProfileRequest: updateProfileRequest,
        ),
      ).thenAnswer((_) async => Success(driverEntity));

      final result = await useCase.call(
        editProfileRequest: updateProfileRequest,
      );

      expect(result, isA<Success<DriverEntity>>());
      expect((result as Success<DriverEntity>).data, driverEntity);
      verify(
        mockProfileRepo.updateProfileData(
          editProfileRequest: updateProfileRequest,
        ),
      ).called(1);
    },
  );

  test(
    'should return Failure<DriverEntity> when repo returns failure',
    () async {
      const errorMessage = 'errors.unexpected';
      when(
        mockProfileRepo.updateProfileData(
          editProfileRequest: updateProfileRequest,
        ),
      ).thenAnswer((_) async => Failure(errorMessage));

      final result = await useCase.call(
        editProfileRequest: updateProfileRequest,
      );
      expect(result, isA<Failure<DriverEntity>>());
      expect((result as Failure<DriverEntity>).errorMessage, errorMessage);
      verify(
        mockProfileRepo.updateProfileData(
          editProfileRequest: updateProfileRequest,
        ),
      ).called(1);
    },
  );
}
