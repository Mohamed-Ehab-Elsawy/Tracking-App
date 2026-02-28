import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

@injectable
class GetOrdersUseCase {
  final HomeRepo _homeRepo;
  const GetOrdersUseCase(this._homeRepo);

  Future<Result<List<HomeOrderEntity>>> invoke(int page, int limit) async {
    return await _homeRepo.getOrders(page, limit);
  }
}
