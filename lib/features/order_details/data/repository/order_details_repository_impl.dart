import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/env/env.dart';
import 'package:tracking_app/core/api/models/responses/directions_model.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/services/location_manager.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/api_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/data_sources/api_order_details_data_source_impl.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_request.dart';
import 'package:tracking_app/features/order_details/data/models/update_order_state_response.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repository.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final FirebaseOrderDetailsDataSource _dataSource;
  final UpdateOrderStateDataSource _apiDataSource;
  final ApiClient _apiClient;

  OrderDetailsRepositoryImpl(this._dataSource, this._apiClient, this._apiDataSource);

  @override
  Future<Result<ActiveOrderDto>> updateOrderStatus(OrderStatus status) async {
    final orderId = await AppLocalStorage.getString(key: AppConstants.orderId);
    final currentLocation = await _getCurrentLocation();
    return await _dataSource.updateOrderStatus(
      orderId,
      currentLocation[0],
      currentLocation[1],
      status,
    );
  }

  Future<List<double>> _getCurrentLocation() async {
    LocationManager locationManager = LocationManager();
    final location = await locationManager.getUserLocation();
    if (location != null) {
      final lat = location.latitude ?? 0.0;
      final lng = location.longitude ?? 0.0;
      return [lat, lng];
    } else {
      return [0.0, 0.0];
    }
  }

  @override
  Future<Result<ActiveOrderDto>> getCurrentOrderDetails() async {
    final id = await AppLocalStorage.getSecuredString(
      key: AppConstants.orderId,
    );
    return _dataSource.getCurrentOrderDetails(id);
  }

  @override
  Future<Result<List<List<double>>>> getDirections({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    final String coordinates = "$startLng,$startLat;$endLng,$endLat";
    final String token = Env.mapAccessToken;
    final response = await executeApi(
      () => _apiClient.getRoute(
        AppConstants.driving,
        coordinates,
        AppConstants.geometries,
        token,
      ),
    );
    switch (response) {
      case Success<DirectionsResponse>():
        final routes = response.data.routes;
        if (routes.isEmpty) {
          return Failure('No route found between these coordinates');
        }
        return Success(routes[0].geometry.coordinates);
      case Failure<DirectionsResponse>():
        return Failure(response.errorMessage);
    }
  }

  @override
  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  }) {
    return _dataSource.sendNotification(
      sendNotificationRequest: notificationDto,
      authorization: authorization,
    );
  }

  @override
  Future<Result<void>> saveNotification({
    required NotificationDto notification,
    required String userId,
  }) {
    return _dataSource.saveNotification(
      notification: notification,
      userId: userId,
    );
  }

  @override
  Future<Result<UpdateOrderStateResponse>> updateOrderState({required UpdateOrderStateRequest updateOrderStateResponse, required String orderId})async {
      final response = await _apiDataSource.updateOrderState(
        updateOrderStateResponse: updateOrderStateResponse,
        orderId: orderId,
      );
      switch (response) {
        case Success<UpdateOrderStateResponse>():
          {

            return Success<UpdateOrderStateResponse>(response.data);
          }
        case Failure<UpdateOrderStateResponse>():
          return Failure<UpdateOrderStateResponse>(response.errorMessage);
      }


  }
}
