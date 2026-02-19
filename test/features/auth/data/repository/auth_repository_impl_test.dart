import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/data/repository/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  // Arrange
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(mockAuthRemoteDataSource);
  });

  group("Change Password Function Test Cases", () {
    late String password;
    late String newPassword;
    late ChangePasswordResponse changePasswordResponse;
    late Success<ChangePasswordResponse> successResponse;
    late Failure<ChangePasswordResponse> failureResponse;

    setUp(() {
      password = "oldPassword123";
      newPassword = "newPassword456";
      changePasswordResponse = ChangePasswordResponse(
        message: "Password changed successfully",
      );
      successResponse = Success<ChangePasswordResponse>(changePasswordResponse);
      failureResponse = Failure<ChangePasswordResponse>(
        "errors.connectionError",
      );
    });

    test("when call changePassword Success Case", () async {
      // Arrange
      provideDummy<Result<ChangePasswordResponse>>(successResponse);
      when(
        mockAuthRemoteDataSource.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).thenAnswer((_) async => successResponse);

      // Act
      final result = await authRepositoryImpl.changePassword(
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
        mockAuthRemoteDataSource.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
    });

    test(
      "when changePassword returns Failure it should return Failure",
      () async {
        // Arrange
        provideDummy<Result<ChangePasswordResponse>>(failureResponse);
        when(
          mockAuthRemoteDataSource.changePassword(
            password: password,
            newPassword: newPassword,
          ),
        ).thenAnswer((_) async => failureResponse);

        // Act
        final result = await authRepositoryImpl.changePassword(
          password: password,
          newPassword: newPassword,
        );

        // Assertion And Verification
        expect(result, isA<Failure<ChangePasswordResponse>>());
        expect(
          (result as Failure<ChangePasswordResponse>).errorMessage,
          equals("errors.connectionError"),
        );
        verify(
          mockAuthRemoteDataSource.changePassword(
            password: password,
            newPassword: newPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });
}
