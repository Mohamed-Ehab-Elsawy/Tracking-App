import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';

abstract class OrderRepo {
  Future<Result<List<OrdersListEntity>>> getAllDriverOrders();
}
