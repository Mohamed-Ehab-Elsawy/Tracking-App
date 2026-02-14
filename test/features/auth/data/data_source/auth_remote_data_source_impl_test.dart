import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/model/response/metadata.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late ApiClient mockApiClient;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockApiClient);
  });
  group('getAllVehicles', () {
    test('when call getAllVehicles should return Success', () async {
      // Arrange
      List<Vehicles> vehicles = [
        Vehicles(type: "vehicle1"),
        Vehicles(type: "vehicle2"),
      ];
      final tResponse = GetAllVehiclesResponse(
        message: "success",
        vehicles: vehicles,
        metadata: Metadata(
          currentPage: 1,
          totalItems: 1,
          limit: 1,
          totalPages: 1,
        ),
      );
      when(mockApiClient.getAllVehicles()).thenAnswer((_) async => tResponse);

      // Act
      final result = await authRemoteDataSourceImpl.getAllVehicles();

      // Assert
      expect(result, isA<Success<GetAllVehiclesResponse>>());
      expect((result as Success<GetAllVehiclesResponse>).data, tResponse);
      expect(result.data.vehicles?.length, tResponse.vehicles?.length);
      verify(mockApiClient.getAllVehicles()).called(1);
    });

    test('when call getAllVehicles should return Failure', () async {
      // Arrange
      final tResponse = GetAllVehiclesResponse(message: "Network Error");
      when(mockApiClient.getAllVehicles()).thenThrow(Exception(tResponse));

      // Act
      final result = await authRemoteDataSourceImpl.getAllVehicles();

      // Assert
      expect(result, isA<Failure<GetAllVehiclesResponse>>());
      expect(
        (result as Failure<GetAllVehiclesResponse>).errorMessage,
        "errors.unexpected",
      );
      verify(mockApiClient.getAllVehicles()).called(1);
    });
  });

  group('apply driver account test cases', () {
    test('when call apply should return Success', () async {
      // Arrange
      final tempDir = Directory.systemTemp.createTempSync();
      final idFile = File('${tempDir.path}/id.jpg')..createSync();
      final licenseFile = File('${tempDir.path}/license.jpg')..createSync();

      final Vehicles vehicle = Vehicles(id: "1", type: "vehicle1");
      final tRequest = ApplyRequest(
        country: "Egypt",
        firstName: "Ahmed",
        lastName: "Ali",
        email: "test@test.com",
        password: "password",
        rePassword: "password",
        gender: "male",
        phone: "0123456789",
        nID: "123456789",
        vehicleType: vehicle,
        vehicleNumber: "123456",
      );
      final tResponse = ApplyResponse(message: "success");

      when(
        mockApiClient.apply(
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any, // الـ nidMultipart
          any, // الـ vehicleLicenseMultipart
        ),
      ).thenAnswer((_) async => tResponse);

      // Act
      final result = await authRemoteDataSourceImpl.apply(
        tRequest,
        nidImage: idFile,
        vehicleLicense: licenseFile,
      );

      // Assert
      expect(result, isA<Success<ApplyResponse>>());
      expect((result as Success).data.message, "success");

      verify(
        mockApiClient.apply(
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
        ),
      ).called(1);

      tempDir.deleteSync(recursive: true);
    });
    test('when call apply should return Failure', () async {
      // Arrange
      final tempDir = Directory.systemTemp.createTempSync();
      final idFile = File('${tempDir.path}/id.jpg')..createSync();
      final licenseFile = File('${tempDir.path}/license.jpg')..createSync();

      final Vehicles vehicle = Vehicles(id: "1", type: "vehicle1");
      final tRequest = ApplyRequest(
        country: "Egypt",
        firstName: "Ahmed",
        lastName: "Ali",
        email: "test@test.com",
        password: "password",
        rePassword: "password",
        gender: "male",
        phone: "0123456789",
        nID: "123456789",
        vehicleType: vehicle,
        vehicleNumber: "123456",
      );
      final tResponse = ApplyResponse(message: "Network Error");

      when(
        mockApiClient.apply(
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
        ),
      ).thenThrow(Exception(tResponse));

      // Act
      final result = await authRemoteDataSourceImpl.apply(
        tRequest,
        nidImage: idFile,
        vehicleLicense: licenseFile,
      );

      // Assert
      expect(result, isA<Failure<ApplyResponse>>());
      expect(
        (result as Failure<ApplyResponse>).errorMessage,
        "errors.unexpected",
      );

      verify(
        mockApiClient.apply(
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
          any,
        ),
      ).called(1);

      tempDir.deleteSync(recursive: true);
    });
  });
}
