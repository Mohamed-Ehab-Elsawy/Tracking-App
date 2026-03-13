import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/client/api_client.dart';
import 'package:tracking_app/core/api/env/env.dart';
import 'package:tracking_app/core/api/models/responses/directions_model.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final FirebaseFirestore _firestore;
  final ApiClient _apiClient;

  OrderDetailsRepoImpl(this._firestore, this._apiClient);

  @override
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId}) async {
    try {
      final id =
          orderId ?? await AppLocalStorage.getString(key: AppConstants.orderId);

      final doc = await _firestore.collection('orders').doc(id).get();

      if (doc.data() == null) return Failure('not_found');

      return Success(OrderEntity.fromMap(doc.data()!));
    } on FirebaseException catch (e) {
      return Failure(e.message ?? 'something_went_wrong');
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<List<List<double>>>> getDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    final String coordinates = "$startLng,$startLat;$endLng,$endLat";
    final String token = Env.mapAccessToken;
    final response = await executeApi(
      () => _apiClient.getRoute(AppConstants.driving, coordinates, AppConstants.geometries, token),
    );
    switch (response) {
      case Success<DirectionsResponse>():
        return Success(response.data.routes[0].geometry.coordinates);
      case Failure<DirectionsResponse>():
        return Failure(response.errorMessage);
    }
  }
}
