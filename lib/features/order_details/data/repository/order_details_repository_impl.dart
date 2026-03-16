import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/env/env.dart';
import 'package:tracking_app/core/api/models/responses/directions_model.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import '../../../../core/api/client/api_client.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource _orderDetailsRemoteDataSource;
  final ApiClient _apiClient;

  OrderDetailsRepositoryImpl(this._orderDetailsRemoteDataSource,
      this._apiClient,);

  @override
  Future<Result<ActiveOrderDto>> getCurrentOrderDetails(
      {String? orderId}) async {
    final id =
        orderId ??
            await AppLocalStorage.getSecuredString(key: AppConstants.orderId);
    return _orderDetailsRemoteDataSource.getCurrentOrderDetails(id);
  }

  @override
  Future<Result<ActiveOrderDto>> updateOrderStatus(OrderStatus status) async {
    final id = await AppLocalStorage.getString(key: AppConstants.orderId);

    return _orderDetailsRemoteDataSource.updateOrderStatus(id, status);
  }

  @override
  Future<Result<List<List<double>>>> getDirections(double startLat,
      double startLng,
      double endLat,
      double endLng,) async {
    final String coordinates = "$startLng,$startLat;$endLng,$endLat";
    final String token = Env.mapAccessToken;
    final response = await executeApi(
          () =>
          _apiClient.getRoute(
        AppConstants.driving,
        coordinates,
        AppConstants.geometries,
        token,
      ),
    );
    switch (response) {
      case Success<DirectionsResponse>():
        return Success(response.data.routes[0].geometry.coordinates);
      case Failure<DirectionsResponse>():
        return Failure(response.errorMessage);
    }
  }
}
