import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/data_source/order_data_source.dart';
import 'package:tracking_app/features/orders/data/models/response/order_response_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_dto.dart';
import 'package:tracking_app/features/orders/data/models/response/product_response.dart';

@Injectable(as: OrdersDataSource)
class OrdersDataSourceImpl implements OrdersDataSource {
  final ApiClient _apiClient;

  OrdersDataSourceImpl(this._apiClient);

  @override
  Future<Result<List<OrdersListDto>>> getAllDriverOrders() {
    return executeApi<List<OrdersListDto>>(() async {
      final OrderResponseDto orderResponse = await _apiClient
          .getAllDriverOrders();

      return orderResponse.orders ?? [];
    });
  }

  @override
  Future<Result<ProductDto>> getProductDetails(String productId) {
    return executeApi<ProductDto>(() async {
      final ProductResponse productResponse = await _apiClient
          .getProductDetails(productId);

      return productResponse.product ?? ProductDto();
    });
  }
}
