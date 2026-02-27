import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_cases/change_password_use_case/change_password_use_case.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late String password;
  late String newPassword;
  late ChangePasswordResponse changePasswordResponse;
  late Success<ChangePasswordResponse> successResponse;
  late Failure<ChangePasswordResponse> failureResponse;
  late MockAuthRepository mockAuthRepository;
  late ChangePasswordUseCase changePasswordUseCase;

  setUp(() {
    password = "oldPassword123";
    newPassword = "newPassword456";
    changePasswordResponse = ChangePasswordResponse(
      message: "Password changed successfully",
    );
    successResponse = Success<ChangePasswordResponse>(changePasswordResponse);
    failureResponse = Failure<ChangePasswordResponse>("errors.connectionError");
    mockAuthRepository = MockAuthRepository();
    changePasswordUseCase = ChangePasswordUseCase(mockAuthRepository);
  });

  test(
    'should return Success with correct message when changePassword succeeds',
    () async {
      // Arrange
      provideDummy<Result<ChangePasswordResponse>>(successResponse);
      when(
        mockAuthRepository.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).thenAnswer((_) async => successResponse);

      // Act
      final result = await changePasswordUseCase.call(
        password: password,
        newPassword: newPassword,
      );

      // Assertion And Verifications
      expect(result, isA<Success<ChangePasswordResponse>>());
      expect(
        (result as Success<ChangePasswordResponse>).data.message,
        equals(changePasswordResponse.message),
      );
      verify(
        mockAuthRepository.changePassword(
          password: password,
          newPassword: newPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should return Failure when changePassword fails', () async {
    // Arrange
    provideDummy<Result<ChangePasswordResponse>>(failureResponse);
    when(
      mockAuthRepository.changePassword(
        password: password,
        newPassword: newPassword,
      ),
    ).thenAnswer((_) async => failureResponse);

    // Act
    final result = await changePasswordUseCase.call(
      password: password,
      newPassword: newPassword,
    );

    // Assertion And Verifications
    expect(result, isA<Failure<ChangePasswordResponse>>());
    expect(
      (result as Failure<ChangePasswordResponse>).errorMessage,
      equals("errors.connectionError"),
    );
    verify(
      mockAuthRepository.changePassword(
        password: password,
        newPassword: newPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
