import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource _orderDetailsRemoteDataSource;

  OrderDetailsRepositoryImpl(this._orderDetailsRemoteDataSource);

  @override
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId}) async {
    final id =
        orderId ?? await AppLocalStorage.getString(key: AppConstants.orderId);

    return _orderDetailsRemoteDataSource.getCurrentOrderDetails(id);
  }

  @override
  Future<Result<OrderEntity>> updateOrderStatus(OrderStatus status) async {
    final id = await AppLocalStorage.getString(key: AppConstants.orderId);

    return _orderDetailsRemoteDataSource.updateOrderStatus(id, status);
  }
}
