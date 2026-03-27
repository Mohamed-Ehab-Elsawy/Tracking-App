import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/order_entity.dart';

import '../entities/user_entity.dart';

abstract interface class HomeRepo {
  Future<Result<List<HomeOrderEntity>>> getOrders(int page, int limit);
  Future<Result<OrdersEntity>> acceptOrder({required String orderId});
  Future<Result<UserEntity>> getUserDetails({String? userId});
  Future<Result<ActiveOrderEntity>> saveAcceptedOrder({
    required String userId,
    required String userToken,
    required String driverId,
    required String driverToken,
    required String orderId,
    required HomeOrderEntity orderEntity,
    required String driverName,
    required String driverPhone,
  });
}
