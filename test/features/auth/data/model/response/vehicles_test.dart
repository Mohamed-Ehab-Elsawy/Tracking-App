import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';

void main() {
  group("Vehicles model", () {
    test("fromJson creates correct object", () {
      final json = {
        "_id": "1",
        "type": "Car",
        "image": "car.png",
        "createdAt": "2024-01-01",
        "updatedAt": "2024-01-02",
        "__v": 3,
      };

      final vehicle = Vehicles.fromJson(json);

      expect(vehicle.id, "1");
      expect(vehicle.type, "Car");
      expect(vehicle.image, "car.png");
      expect(vehicle.createdAt, "2024-01-01");
      expect(vehicle.updatedAt, "2024-01-02");
      expect(vehicle.v, 3);
    });

    test("toJson returns correct map", () {
      final vehicle = Vehicles(
        id: "10",
        type: "Bike",
        image: "bike.png",
        createdAt: "2024-02-01",
        updatedAt: "2024-02-02",
        v: 1,
      );

      final json = vehicle.toJson();

      expect(json, {
        "_id": "10",
        "type": "Bike",
        "image": "bike.png",
        "createdAt": "2024-02-01",
        "updatedAt": "2024-02-02",
        "__v": 1,
      });
    });

    test("handles null values safely", () {
      final vehicle = Vehicles();

      final json = vehicle.toJson();

      expect(json, {
        "_id": null,
        "type": null,
        "image": null,
        "createdAt": null,
        "updatedAt": null,
        "__v": null,
      });
    });
  });
}
