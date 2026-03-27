import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_sources/api_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_request.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_response.dart';
@Injectable(as: UpdateOrderStateDataSource)
class ApiOrderDetailsDataSourceImpl implements UpdateOrderStateDataSource {
  final ApiClient _apiClient;
  ApiOrderDetailsDataSourceImpl(this._apiClient);

  @override
  Future<Result<UpdateOrderStateResponse>> updateOrderState({required UpdateOrderStateRequest updateOrderStateResponse, required String orderId}) {
    return executeApi(() async {
          final response = await _apiClient.updateOrderStatus(updateOrderStateResponse, orderId);
          return response;

        });
  }

}