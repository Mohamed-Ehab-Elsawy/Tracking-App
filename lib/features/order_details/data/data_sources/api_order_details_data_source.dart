import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_request.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_response.dart';

abstract class UpdateOrderStateDataSource {
  Future<Result<UpdateOrderStateResponse>> updateOrderState({
    required UpdateOrderStateRequest updateOrderStateResponse,
    required String orderId,
  });

}