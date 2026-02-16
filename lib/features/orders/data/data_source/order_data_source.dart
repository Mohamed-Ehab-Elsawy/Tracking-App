import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';

abstract class OrdersDataSource {
  Future<Result<List<OrdersListDto>>> getAllDriverOrders();
}
