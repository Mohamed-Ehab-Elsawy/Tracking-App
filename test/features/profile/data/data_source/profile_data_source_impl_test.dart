import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/data_source/profile_data_source_impl.dart';
import 'package:tracking_app/features/profile/data/model/driver_dto.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/data/model/response/driver_data_response.dart';

import 'profile_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late ProfileDataSourceImpl dataSourceImpl;
  late MockApiClient apiClient;
  late DriverDataResponse dataResponse;
  late DriverDto driverDto;
  late String errorMessage;
  late UpdateProfileRequest updateProfileRequest;
  setUp(() {
    apiClient = MockApiClient();
    dataSourceImpl = ProfileDataSourceImpl(apiClient);
    driverDto = DriverDto(
      firstName: "s",
      lastName: "s",
      email: "s",
      phone: "s",
    );
    dataResponse = DriverDataResponse(message: "s", driverDto: driverDto);
    errorMessage = "errors.unexpected";
    updateProfileRequest = UpdateProfileRequest(firstName: "s", lastName: "s");
  });
  group("test getDriverData in data source", () {
    test(
      'test call getDriverData should return DriverDataResponse with success',
      () async {
        when(apiClient.getDriverData()).thenAnswer((_) async => dataResponse);
        final result = await dataSourceImpl.getDriverData();
        expect(result, Success<DriverDataResponse>(dataResponse));
        expect(
          (result as Success<DriverDataResponse>).data.driverDto?.firstName,
          equals(driverDto.firstName),
        );
        expect(result.data.driverDto?.lastName, equals(driverDto.lastName));
        expect(result.data.driverDto?.email, equals(driverDto.email));
        expect(result.data.driverDto?.phone, equals(driverDto.phone));

        verify(apiClient.getDriverData());
      },
    );
    test(
      'test call getDriverData should return DriverDataResponse with success',
      () async {
        when(apiClient.getDriverData()).thenThrow(Exception(errorMessage));
        final result = await dataSourceImpl.getDriverData();
        expect(result, isA<Failure<DriverDataResponse>>());
        expect(
          (result as Failure<DriverDataResponse>).errorMessage,
          equals(errorMessage),
        );
        verify(apiClient.getDriverData());
      },
    );
  });
  group("test updateProfileData in data source", () {
    test(
      'test call updateProfileData should return DriverDataResponse with success',
      () async {
        when(
          apiClient.updateProfile(updateProfileRequest),
        ).thenAnswer((_) async => dataResponse);
        final result = await dataSourceImpl.updateProfileData(
          editProfileRequest: updateProfileRequest,
        );
        expect(result, Success<DriverDataResponse>(dataResponse));
        expect(
          (result as Success<DriverDataResponse>).data.driverDto?.firstName,
          equals(driverDto.firstName),
        );
        expect(result.data.driverDto?.lastName, equals(driverDto.lastName));
        expect(result.data.driverDto?.email, equals(driverDto.email));
        expect(result.data.driverDto?.phone, equals(driverDto.phone));
        verify(apiClient.updateProfile(updateProfileRequest));
      },
    );
    test(
      'test call updateProfileData should return DriverDataResponse with success',
      () async {
        when(
          apiClient.updateProfile(updateProfileRequest),
        ).thenThrow(Exception(errorMessage));
        final result = await dataSourceImpl.updateProfileData(
          editProfileRequest: updateProfileRequest,
        );
        expect(result, isA<Failure<DriverDataResponse>>());
        expect(
          (result as Failure<DriverDataResponse>).errorMessage,
          equals(errorMessage),
        );
        verify(apiClient.updateProfile(updateProfileRequest));
      },
    );
  });
}
