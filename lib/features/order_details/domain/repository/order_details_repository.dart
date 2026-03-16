import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

abstract interface class OrderDetailsRepository {
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId});

  Future<Result<OrderEntity>> updateOrderStatus(OrderStatus status);
  Future<Result<List<List<double>>>> getDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  );
}
