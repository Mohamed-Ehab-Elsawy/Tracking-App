import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/services/notification_dto.dart';

void main() {
  group("SendNotificationRequest.toJson()", () {
    test("serializes correctly with data", () {
      final request = SendNotificationRequest(
        "target-token-123",
        "Hello",
        "This is body",
        {"orderId": "789", "type": "delivery"},
      );

      final json = request.toJson();

      expect(json, {
        "message": {
          "token": "target-token-123",
          "notification": {"title": "Hello", "body": "This is body"},
          "data": {"orderId": "789", "type": "delivery"},
          "android": {
            "priority": "high",
            "notification": {"channel_id": "high_importance_channel"},
          },
          "apns": {
            "headers": {"apns-priority": "10"},
          },
        },
      });
    });

    test("serializes correctly when data is null (empty {})", () {
      final request = SendNotificationRequest(
        "token-001",
        "Title",
        "Body",
        null,
      );

      final json = request.toJson();

      expect(json["message"]["data"], equals({}));
    });

    test("ensures android & apns blocks are always included", () {
      final request = SendNotificationRequest("token-aa", "Test", "Body", {});

      final json = request.toJson();

      expect(json["message"]["android"], isA<Map>());
      expect(json["message"]["android"]["priority"], "high");
      expect(
        json["message"]["android"]["notification"]["channel_id"],
        "high_importance_channel",
      );

      expect(json["message"]["apns"], isA<Map>());
      expect(json["message"]["apns"]["headers"]["apns-priority"], "10");
    });
  });
}
