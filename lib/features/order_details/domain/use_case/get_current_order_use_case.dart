import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';

@injectable
class GetCurrentOrderUseCase {
  final OrderDetailsRepository _orderDetailsRepo;

  GetCurrentOrderUseCase(this._orderDetailsRepo);

  Future<Result<OrderEntity>> call() =>
      _orderDetailsRepo.getCurrentOrderDetails();
}
