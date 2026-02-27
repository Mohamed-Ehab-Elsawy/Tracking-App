import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';
import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
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
}
