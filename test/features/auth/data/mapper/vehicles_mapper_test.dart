import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/mapper/vehicles_mapper.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

void main() {
  group('VehiclesMapperX Tests', () {
    test('should map Vehicles model to VehicleEntity correctly', () {
      final tModel = Vehicles(id: "1", type: "Truck");

      final result = tModel.toEntity();

      expect(result.id, tModel.id);
      expect(result.type, tModel.type);
    });

    test('should return default values when model fields are null', () {
      final tModel = Vehicles(id: null, type: null);

      final result = tModel.toEntity();

      expect(result.id, "");
      expect(result.type, "");
    });
  });

  group('VehicleEntityExtension Tests', () {
    test('should map VehicleEntity to Vehicles model correctly', () {
      final tEntity = VehicleEntity(id: "2", type: "Motorcycle");

      final result = tEntity.toModel();

      expect(result.id, tEntity.id);
      expect(result.type, tEntity.type);
    });
  });
}
