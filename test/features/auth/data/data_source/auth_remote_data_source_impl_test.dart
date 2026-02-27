import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/model/response/metadata.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late ApiClient mockApiClient;
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late DioException dioException;

  setUp(() {
    mockApiClient = MockApiClient();
    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(mockApiClient);
    dioException = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.connectionError,
    );
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
          any,
          // الـ nidMultipart
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
  const tUserDto = UserDto(email: 'test@example.com', code: '123456');
  group('emailVerification', () {
    const tResponse = EmailVerificationResponseDto(message: 'Success');

    test(
      'should return Success when the call to ApiClient is successful',
      () async {
        // Arrange
        when(
          mockApiClient.emailVerification(userDto: tUserDto),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await authRemoteDataSourceImpl.emailVerification(
          tUserDto,
        );

        // Assert
        expect(result, isA<Success<EmailVerificationResponseDto>>());
        expect((result as Success).data, tResponse);
        verify(mockApiClient.emailVerification(userDto: tUserDto));
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return Failure when the call to ApiClient throws an exception',
      () async {
        // Arrange
        when(
          mockApiClient.emailVerification(userDto: tUserDto),
        ).thenThrow(Exception());

        // Act
        final result = await authRemoteDataSourceImpl.emailVerification(
          tUserDto,
        );

        // Assert
        expect(result, isA<Failure>());
        verify(mockApiClient.emailVerification(userDto: tUserDto));
      },
    );
  });

  group('codeVerification', () {
    const tResponse = VerificationCodeResponseDto(status: 'Success');

    test(
      'should return Success when the call to ApiClient is successful',
      () async {
        // Arrange
        when(
          mockApiClient.verifyResetPasswordCode(userDto: tUserDto),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await authRemoteDataSourceImpl.codeVerification(
          tUserDto,
        );

        // Assert
        expect(result, isA<Success<VerificationCodeResponseDto>>());
        expect((result as Success).data, tResponse);
        verify(mockApiClient.verifyResetPasswordCode(userDto: tUserDto));
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return Failure when the call to ApiClient throws an exception',
      () async {
        // Arrange
        when(
          mockApiClient.verifyResetPasswordCode(userDto: tUserDto),
        ).thenThrow(Exception());

        // Act
        final result = await authRemoteDataSourceImpl.codeVerification(
          tUserDto,
        );

        // Assert
        expect(result, isA<Failure>());
        verify(mockApiClient.verifyResetPasswordCode(userDto: tUserDto));
      },
    );
  });

  group('resetPassword', () {
    const tResponse = ResetPasswordResponseDto(
      message: 'Success',
      token: 'token',
    );

    test(
      'should return Success when the call to ApiClient is successful',
      () async {
        // Arrange
        when(
          mockApiClient.resetPassword(userDto: tUserDto),
        ).thenAnswer((_) async => tResponse);

        // Act
        final result = await authRemoteDataSourceImpl.resetPassword(tUserDto);

        // Assert
        expect(result, isA<Success<ResetPasswordResponseDto>>());
        expect((result as Success).data, tResponse);
        verify(mockApiClient.resetPassword(userDto: tUserDto));
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test(
      'should return Failure when the call to ApiClient throws an exception',
      () async {
        // Arrange
        when(
          mockApiClient.resetPassword(userDto: tUserDto),
        ).thenThrow(Exception());

        // Act
        final result = await authRemoteDataSourceImpl.resetPassword(tUserDto);

        // Assert
        expect(result, isA<Failure>());
        verify(mockApiClient.resetPassword(userDto: tUserDto));
      },
    );
  });
  group("Test Login cases", () {
    late String email, password;
    late DriverLoginRequestDTO requestDTO;
    late DriverLoginResponseDTO responseDTO;
    setUp(() {
      email = "mooehab03@gmail.com";
      password = "Mohamed@123";
      requestDTO = DriverLoginRequestDTO(email, password);
      responseDTO = DriverLoginResponseDTO(token: "token", message: "success");
    });
    test("Success Login case it should return user token", () async {
      // arrange
      when(
        mockApiClient.login(requestDTO),
      ).thenAnswer((_) async => responseDTO);
      // act
      final result =
          await authRemoteDataSourceImpl.login(email, password)
              as Success<String>;
      // assert
      expect(result, isA<Success<String>>());
      expect(result.data, responseDTO.token);
      verify(mockApiClient.login(requestDTO)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test("Failure Login case it should return error message", () async {
      // arrange
      when(mockApiClient.login(requestDTO)).thenThrow(dioException);
      // act
      final result = await authRemoteDataSourceImpl.login(email, password);
      // assert
      expect(result, isA<Failure<String>>());
      expect(
        (result as Failure<String>).errorMessage,
        'errors.connectionError',
      );
      verify(mockApiClient.login(requestDTO)).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group("Change Password Function Test Cases", () {
    late String password;
    late String newPassword;
    late ChangePasswordResponse changePasswordResponse;

    setUp(() {
      password = "oldPassword123";
      newPassword = "newPassword456";
      changePasswordResponse = ChangePasswordResponse(
        message: "Password changed successfully",
      );
    });

    test("when call changePassword it should return Success", () async {
      // Arrange
      when(
        mockApiClient.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).thenAnswer((_) async => changePasswordResponse);

      // Act
      final result = await authRemoteDataSourceImpl.changePassword(
        password: password,
        newPassword: newPassword,
      );

      // Assertion And Verification
      expect(result, isA<Success<ChangePasswordResponse>>());
      expect(
        (result as Success<ChangePasswordResponse>).data.message,
        equals(changePasswordResponse.message),
      );
      verify(
        mockApiClient.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });

    test(
      "when changePassword throws exception it should return Failure",
      () async {
        // Arrange
        when(
          mockApiClient.changePassword(
            password: password,
            newPassword: newPassword,
          ),
        ).thenThrow(dioException);

        // Act
        final result = await authRemoteDataSourceImpl.changePassword(
          password: password,
          newPassword: newPassword,
        );

        // Assertion And Verifications
        expect(result, isA<Failure>());
        expect(
          (result as Failure).errorMessage,
          equals("errors.connectionError"),
        );
        verify(
          mockApiClient.changePassword(
            password: password,
            newPassword: newPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );
  });
}
