import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@injectable
class UpdateOrderStatusUseCase {
  final OrderDetailsRepository _orderDetailsRepo;

  UpdateOrderStatusUseCase(this._orderDetailsRepo);

  Future<Result<OrderEntity>> call(OrderStatus status) =>
      _orderDetailsRepo.updateOrderStatus(status);
}
