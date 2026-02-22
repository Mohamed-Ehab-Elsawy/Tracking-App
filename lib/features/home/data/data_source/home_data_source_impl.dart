import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  final ApiClient _apiClient;

  const HomeDataSourceImpl(this._apiClient);
  @override
  Future<Result<HomeResponseDto>> getOrders(int page, int limit) {
    return executeApi(() async => await _apiClient.getOrders(page, limit));
  }
}
