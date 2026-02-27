import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/api/models/requests/driver_login_request_dto.dart';

void main() {
  const tEmail = 'driver@example.com';
  const tPassword = 'password123';

  final tJson = {'email': tEmail, 'password': tPassword};

  final tModel = DriverLoginRequestDTO(tEmail, tPassword);

  group('DriverLoginRequestDTO', () {
    test('should be a subclass of Equatable (properly compares objects)', () {
      final model1 = DriverLoginRequestDTO(tEmail, tPassword);
      final model2 = DriverLoginRequestDTO(tEmail, tPassword);

      expect(model1, equals(model2));
    });

    test("fromJson should return a valid model when JSON is provided", () {
      // Act
      final result = DriverLoginRequestDTO.fromJson(tJson);

      // Assert
      expect(result, tModel);
      expect(result.email, tEmail);
      expect(result.password, tPassword);
    });

    test("toJson should return a JSON map containing the proper data", () {
      // Act
      final result = tModel.toJson();

      // Assert
      expect(result, tJson);
    });
  });
}
