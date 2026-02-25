import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

abstract interface class OrderDetailsRepo {
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId});
}
