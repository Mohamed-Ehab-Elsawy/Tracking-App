import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_response.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';

import '../../data/models/update_order_state_request.dart';

@injectable
class UpdateOrderStatusUseCaseApi {
  final OrderDetailsRepository _orderDetailsRepo;

  UpdateOrderStatusUseCaseApi(this._orderDetailsRepo);

  Future<Result<UpdateOrderStateResponse>> call(UpdateOrderStateRequest  updateOrderStateResponse,String orderId) =>
      _orderDetailsRepo.updateOrderState(updateOrderStateResponse: updateOrderStateResponse, orderId: orderId );
}
