import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';

abstract interface class HomeRepo {
  Future<Result<List<HomeOrderEntity>>> getOrders(int page, int limit);
}
