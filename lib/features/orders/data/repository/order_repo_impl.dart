import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/data_source/order_data_source.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/repository/order_repo.dart';

@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrdersDataSource dataSource;

  OrderRepoImpl(this.dataSource);
  @override
  Future<Result<List<OrdersListEntity>>> getAllDriverOrders() async {
    Result<List<OrdersListDto>> orderListDto = await dataSource
        .getAllDriverOrders();
    switch (orderListDto) {
      case Success<List<OrdersListDto>>():
        {
          final items = orderListDto.data;
          final order = items.map((dto) => dto.toEntity()).toList();
          return Success(order);
        }
      case Failure<List<OrdersListDto>>():
        {
          return Failure(orderListDto.errorMessage);
        }
    }
  }
}
