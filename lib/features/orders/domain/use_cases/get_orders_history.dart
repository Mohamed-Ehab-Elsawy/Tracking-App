import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/repository/order_repo.dart';

@injectable
class GetOrdersHistoryUseCase {
  OrderRepo orderRepo;

  GetOrdersHistoryUseCase(this.orderRepo);

  Future<Result<List<OrdersListEntity>>> call() =>
      orderRepo.getAllDriverOrders();
}
