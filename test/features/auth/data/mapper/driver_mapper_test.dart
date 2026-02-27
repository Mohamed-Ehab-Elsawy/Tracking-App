import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/mapper/driver_mapper.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

void main() {
  group('DriverMapperX Tests', () {
    test('should map DriverEntity to ApplyRequest correctly', () {
      final tVehicleEntity = VehicleEntity(id: "1", type: "Sedan");
      final tDriverEntity = DriverEntity(
        country: "Egypt",
        firstName: "Abdelrahman",
        lastName: "Ayman",
        vehicleType: tVehicleEntity,
        vehicleNumber: "299925",
        nid: "2990709",
        email: "test@gmail.com",
        password: "password123",
        rePassword: "password123",
        gender: "male",
        phone: "+201017696067",
      );

      final result = tDriverEntity.toRequest();

      expect(result, isA<ApplyRequest>());
      expect(result.country, tDriverEntity.country);
      expect(result.firstName, tDriverEntity.firstName);
      expect(result.lastName, tDriverEntity.lastName);
      expect(result.vehicleType?.id, tDriverEntity.vehicleType?.id);
      expect(result.vehicleNumber, tDriverEntity.vehicleNumber);
      expect(result.nID, tDriverEntity.nid);
      expect(result.email, tDriverEntity.email);
      expect(result.password, tDriverEntity.password);
      expect(result.rePassword, tDriverEntity.rePassword);
      expect(result.gender, tDriverEntity.gender);
      expect(result.phone, tDriverEntity.phone);
    });

    test(
      'should return null vehicleType in request when entity vehicleType is null',
      () {
        final tDriverEntity = DriverEntity(
          country: "Algeria",
          firstName: "Abdelrahman",
          lastName: "Ayman",
          vehicleType: null,
          nid: "12345",
        );

        final result = tDriverEntity.toRequest();

        expect(result.vehicleType, isNull);
      },
    );
  });
}
