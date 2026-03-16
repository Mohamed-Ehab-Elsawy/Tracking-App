import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/order_entity.dart';

import '../repo/home_repo.dart';

@injectable
class AcceptOrderUseCase {
  final HomeRepo _repo;

  AcceptOrderUseCase(this._repo);

  Future<Result<OrdersEntity>> invoke({required String orderId}) {
    return _repo.acceptOrder(orderId: orderId);
  }
}
