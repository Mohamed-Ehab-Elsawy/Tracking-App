import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';

import '../models/update_order_response.dart' show UpdateOrderResponse;

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  final ApiClient _apiClient;

  const HomeDataSourceImpl(this._apiClient);
  @override
  Future<Result<HomeResponseDto>> getOrders(int page, int limit) {
    return executeApi(() async => await _apiClient.getOrders(page, limit));
  }

  @override
  Future<Result<UpdateOrderResponse>> acceptOrder(String orderId) {
    return executeApi(() async => await _apiClient.acceptOrder(orderId));
  }
}
