import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_request.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_response.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

abstract interface class OrderDetailsRepository {
  Future<Result<ActiveOrderDto>> getCurrentOrderDetails();

  Future<Result<ActiveOrderDto>> updateOrderStatus(OrderStatus status);

  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  });

  Future<Result<void>> saveNotification({
    required NotificationDto notification,
    required String userId,
  });

  Future<Result<List<List<double>>>> getDirections({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
  Future<Result<UpdateOrderStateResponse>> updateOrderState({
    required UpdateOrderStateRequest updateOrderStateResponse,
    required String orderId,
  });
}
