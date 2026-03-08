import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/mapper/home_orders_mapper.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeDataSource _homeDataSource;
  const HomeRepoImpl(this._homeDataSource);
  @override
  Future<Result<List<HomeOrderEntity>>> getOrders(int page, int limit) async {
    final response = await _homeDataSource.getOrders(page, limit);

    switch (response) {
      case Success<HomeResponseDto>():
        var result =
            response.data.orders
                ?.map((e) => e.toEntity())
                .toList()
                .reversed
                .toList()
                .reversed
                .toList() ??
            [];
        return Success(result);
      case Failure<HomeResponseDto>():
        return Failure(response.errorMessage);
    }
  }
}
