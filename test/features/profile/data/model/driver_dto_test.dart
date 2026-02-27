import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/profile/data/model/driver_dto.dart';

void main() {
  test('test toEntity in driver dto with null values should return null', () {
    DriverDto driverDto = DriverDto(
      firstName: null,
      lastName: null,
      phone: null,
    );
    final result = driverDto.toEntity();
    expect(result.firstName, isNull);
    expect(result.lastName, isNull);
    expect(result.phone, isNull);
  });
  test(
    'test toEntity in driver dto with true values should return true values',
    () {
      DriverDto driverDto = DriverDto(
        firstName: "abdo",
        lastName: "mohamed",
        phone: "01012345678",
      );
      final result = driverDto.toEntity();
      expect(result.firstName, equals(driverDto.firstName));
      expect(result.lastName, equals(driverDto.lastName));
      expect(result.phone, equals(driverDto.phone));
    },
  );
}
