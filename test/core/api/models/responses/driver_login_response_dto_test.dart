import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/api/models/responses/driver_login_response_dto.dart';

void main() {
  group('DriverLoginResponseDTO', () {
    const tMessage = 'Success';
    const tToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

    final tFullJson = {'message': tMessage, 'token': tToken};

    final tFullModel = DriverLoginResponseDTO(message: tMessage, token: tToken);

    test("fromJson should return a valid model when JSON has all fields", () {
      // Act
      final result = DriverLoginResponseDTO.fromJson(tFullJson);

      // Assert
      expect(result, equals(tFullModel));
    });

    test(
      "fromJson should return a model with null fields when JSON is empty",
      () {
        // Arrange
        final Map<String, dynamic> emptyJson = {};

        // Act
        final result = DriverLoginResponseDTO.fromJson(emptyJson);

        // Assert
        expect(result.message, isNull);
        expect(result.token, isNull);
      },
    );

    test("toJson should return a JSON map containing the proper data", () {
      // Act
      final result = tFullModel.toJson();

      // Assert
      expect(result, equals(tFullJson));
    });

    test(
      "toJson should return a JSON map with null values when fields are null",
      () {
        // Arrange
        final model = DriverLoginResponseDTO(message: null, token: null);

        // Act
        final result = model.toJson();

        // Assert
        expect(result.containsKey('message'), true);
        expect(result['message'], isNull);
      },
    );
  });
}
