import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/domain/use_case/driver_login_use_case.dart';

@GenerateMocks([AuthRepository])
import 'driver_login_use_case_test.mocks.dart';

void main() {
  late DriverLoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = DriverLoginUseCase(mockAuthRepository);
  });

  const tEmail = 'driver@test.com';
  const tPassword = 'password123';
  const tRememberMe = true;
  const tSuccessMessage = 'logged_in_successfully';

  group('DriverLoginUseCase Execution', () {
    test(
      'should call login on the repository with correct parameters and return Success',
      () async {
        // Arrange
        provideDummy<Result<String>>(Success(tSuccessMessage));
        when(
          mockAuthRepository.login(any, any, any),
        ).thenAnswer((_) async => Success(tSuccessMessage));

        // Act
        final result = await useCase(tEmail, tPassword, tRememberMe);

        // Assert
        expect(result, isA<Success<String>>());
        expect((result as Success).data, tSuccessMessage);
        verify(
          mockAuthRepository.login(tEmail, tPassword, tRememberMe),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should return Failure when the repository login fails', () async {
      // Arrange
      final tFailure = Failure<String>('Invalid Credentials');
      provideDummy<Result<String>>(tFailure);
      when(
        mockAuthRepository.login(any, any, any),
      ).thenAnswer((_) async => tFailure);

      // Act
      final result = await useCase(tEmail, tPassword, tRememberMe);

      // Assert
      expect(result, equals(tFailure));
      verify(
        mockAuthRepository.login(tEmail, tPassword, tRememberMe),
      ).called(1);
    });
  });
}
