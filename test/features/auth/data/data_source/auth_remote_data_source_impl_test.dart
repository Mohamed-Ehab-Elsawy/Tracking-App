import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

import '../../../profile/data/data_source/profile_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late AuthRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  late DioException dioException;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
    dioException = DioException(
      requestOptions: RequestOptions(),
      type: DioExceptionType.connectionError,
    );
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
        final result = await dataSource.emailVerification(tUserDto);

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
        final result = await dataSource.emailVerification(tUserDto);

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
        final result = await dataSource.codeVerification(tUserDto);

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
        final result = await dataSource.codeVerification(tUserDto);

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
        final result = await dataSource.resetPassword(tUserDto);

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
        final result = await dataSource.resetPassword(tUserDto);

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
      final result = await dataSource.login(email, password) as Success<String>;
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
      final result = await dataSource.login(email, password);
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
}
