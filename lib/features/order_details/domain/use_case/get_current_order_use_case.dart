import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';

@injectable
class GetCurrentOrderUseCase {
  final OrderDetailsRepository _orderDetailsRepo;

  GetCurrentOrderUseCase(this._orderDetailsRepo);

  Future<Result<ActiveOrderDto>> call() =>
      _orderDetailsRepo.getCurrentOrderDetails();
}
