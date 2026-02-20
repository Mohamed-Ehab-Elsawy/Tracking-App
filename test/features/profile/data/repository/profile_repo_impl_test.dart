import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/data_source/profile_data_source_impl.dart';
import 'package:tracking_app/features/profile/data/model/driver_dto.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';
import 'package:tracking_app/features/profile/data/repository/profile_repo_impl.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileDataSourceImpl])
void main() {
  late MockProfileDataSourceImpl dataSourceImpl;
  late ProfileRepoImpl repoImpl;
  late DriverDto driverDto;
  late String errorMessage;
  late DriverEntity driverEntity;
  late DriverDataResponse dataResponse;
  late UpdateProfileRequest updateProfileRequest;
  setUp(() {
    dataSourceImpl = MockProfileDataSourceImpl();
    repoImpl = ProfileRepoImpl(dataSourceImpl);
    driverDto = DriverDto(
      firstName: "s",
      lastName: "s",
      email: "s",
      phone: "s",
    );
    errorMessage = "errors.unexpected";
    driverEntity = DriverEntity(
      firstName: "s",
      lastName: "s",
      email: "s",
      phone: "s",
    );
    dataResponse = DriverDataResponse(message: "s", driverDto: driverDto);
    updateProfileRequest = UpdateProfileRequest(firstName: "s", lastName: "s");
    provideDummy<Result<DriverDataResponse>>(
      Success<DriverDataResponse>(dataResponse),
    );
  });
  group("test call getDriverData in repo", () {
    test(
      'test call getDriverData should return success with DriverEntity  ',
      () async {
        when(
          dataSourceImpl.getDriverData(),
        ).thenAnswer((_) async => Success<DriverDataResponse>(dataResponse));
        final result = await repoImpl.getDriverData();
        expect(result, Success<DriverEntity>(driverEntity));
        expect(
          (result as Success<DriverEntity>).data.firstName,
          equals(driverDto.firstName),
        );
        expect(result.data.lastName, equals(driverDto.lastName));
        expect(result.data.email, equals(driverDto.email));
        expect(result.data.phone, equals(driverDto.phone));
        verify(repoImpl.getDriverData());
      },
    );
    test(
      'test call getDriverData should return Failure with the error message  ',
      () async {
        when(
          dataSourceImpl.getDriverData(),
        ).thenAnswer((_) async => Failure<DriverDataResponse>(errorMessage));
        final result = await repoImpl.getDriverData();
        expect(result, isA<Failure<DriverEntity>>());
        expect(
          (result as Failure<DriverEntity>).errorMessage,
          equals(errorMessage),
        );
        verify(repoImpl.getDriverData());
      },
    );
  });
  group("test call updateProfileData in repo", () {
    test(
      'test call updateProfileData should return success with DriverEntity  ',
      () async {
        when(
          dataSourceImpl.updateProfileData(
            editProfileRequest: updateProfileRequest,
          ),
        ).thenAnswer((_) async => Success<DriverDataResponse>(dataResponse));
        final result = await repoImpl.updateProfileData(
          editProfileRequest: updateProfileRequest,
        );
        expect(result, Success<DriverEntity>(driverEntity));
        expect(
          (result as Success<DriverEntity>).data.firstName,
          equals(driverDto.firstName),
        );
        expect(result.data.lastName, equals(driverDto.lastName));
        expect(result.data.email, equals(driverDto.email));
        expect(result.data.phone, equals(driverDto.phone));
        verify(
          repoImpl.updateProfileData(editProfileRequest: updateProfileRequest),
        );
      },
    );
    test(
      'test call updateProfileData should return Failure with the error message  ',
      () async {
        when(
          dataSourceImpl.updateProfileData(
            editProfileRequest: updateProfileRequest,
          ),
        ).thenAnswer((_) async => Failure<DriverDataResponse>(errorMessage));
        final result = await repoImpl.updateProfileData(
          editProfileRequest: updateProfileRequest,
        );
        expect(result, isA<Failure<DriverEntity>>());
        expect(
          (result as Failure<DriverEntity>).errorMessage,
          equals(errorMessage),
        );
        verify(
          repoImpl.updateProfileData(editProfileRequest: updateProfileRequest),
        );
      },
    );
  });
}
