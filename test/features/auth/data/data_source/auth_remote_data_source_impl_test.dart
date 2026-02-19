import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
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
