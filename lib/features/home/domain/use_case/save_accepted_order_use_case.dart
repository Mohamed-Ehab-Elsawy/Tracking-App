import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

import '../entities/home_order_entity.dart';

@injectable
class SaveAcceptedOrderUseCase {
  final HomeRepo _repository;

  SaveAcceptedOrderUseCase(this._repository);

  Future<Result<ActiveOrderEntity>> call({
    required String userId,
    required String userToken,
    required String driverId,
    required String driverToken,
    required String orderId,
    required HomeOrderEntity orderEntity,
    required String driverName,
    required String driverPhone,
  }) {
    return _repository.saveAcceptedOrder(
      userId: userId,
      userToken: userToken,
      driverId: driverId,
      driverToken: driverToken,
      orderId: orderId,
      orderEntity: orderEntity,
      driverName: driverName,
      driverPhone: driverPhone,
    );
  }
}
