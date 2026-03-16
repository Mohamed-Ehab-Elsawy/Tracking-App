import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';
import 'package:tracking_app/features/home/data/models/update_order_response.dart';

abstract interface class HomeDataSource {
  Future<Result<HomeResponseDto>> getOrders(int page, int limit);
  Future<Result<UpdateOrderResponse>> acceptOrder(String orderId);
}
