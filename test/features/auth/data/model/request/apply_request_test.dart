import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';

void main() {
  group("ApplyRequest Model", () {
    test("fromJson creates correct ApplyRequest object", () {
      final json = {
        "country": "Egypt",
        "firstName": "John",
        "lastName": "Doe",
        "vehicleType": {
          "_id": "456",
          "type": "Bike",
          "image": "bike.png",
          "createdAt": "2024-02-02",
          "updatedAt": "2024-02-03",
          "__v": 2,
        },
        "vehicleNumber": "ABC123",
        "NID": "99998888",
        "email": "john@mail.com",
        "password": "pass",
        "rePassword": "pass",
        "gender": "male",
        "phone": "01123456789",
      };

      final request = ApplyRequest.fromJson(json);

      expect(request.country, "Egypt");
      expect(request.firstName, "John");
      expect(request.lastName, "Doe");

      final v = request.vehicleType!;
      expect(v.id, "456");
      expect(v.type, "Bike");
      expect(v.image, "bike.png");
      expect(v.createdAt, "2024-02-02");
      expect(v.updatedAt, "2024-02-03");
      expect(v.v, 2);

      expect(request.vehicleNumber, "ABC123");
      expect(request.nID, "99998888");
      expect(request.email, "john@mail.com");
      expect(request.password, "pass");
      expect(request.rePassword, "pass");
      expect(request.gender, "male");
      expect(request.phone, "01123456789");
    });

    test("Equatable works: two identical ApplyRequest objects are equal", () {
      final vehicle = Vehicles(
        id: "1",
        type: "Car",
        image: "img.png",
        createdAt: "2024",
        updatedAt: "2025",
        v: 1,
      );

      final a = ApplyRequest(
        country: "EG",
        firstName: "Ahmed",
        lastName: "Ali",
        vehicleType: vehicle,
        vehicleNumber: "X5",
        nID: "000",
        email: "a@mail.com",
        password: "pass",
        rePassword: "pass",
        gender: "male",
        phone: "012",
      );

      final b = ApplyRequest(
        country: "EG",
        firstName: "Ahmed",
        lastName: "Ali",
        vehicleType: vehicle,
        vehicleNumber: "X5",
        nID: "000",
        email: "a@mail.com",
        password: "pass",
        rePassword: "pass",
        gender: "male",
        phone: "012",
      );

      expect(a, equals(b));
      expect(a.props, b.props);
    });
  });
}
