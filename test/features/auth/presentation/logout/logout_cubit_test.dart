import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';

import 'logout_cubit_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late LogoutCubit logoutCubit;

  group("Logout test", () {
    setUp(() {
      mockAuthRepository = MockAuthRepository();
      logoutCubit = LogoutCubit(mockAuthRepository);
    });
    test(
      "When DriverLogoutIntent is called, logout method should be called",
      () {
        // Arrange
        when(mockAuthRepository.logout()).thenAnswer((_) => {});
        // Act
        logoutCubit.doIntent(DriverLogoutIntent());
        // Assert
        verify(mockAuthRepository.logout()).called(1);
      },
    );
  });
}
