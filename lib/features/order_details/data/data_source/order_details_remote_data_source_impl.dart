import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/firestore_service.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@Injectable(as: OrderDetailsRemoteDataSource)
class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final FirebaseStoreService _firebaseStoreServices;

  OrderDetailsRemoteDataSourceImpl(this._firebaseStoreServices);

  @override
  Future<Result<OrderEntity>> getCurrentOrderDetails(String orderId) async =>
      executeApi(() async {
        final doc = await _firebaseStoreServices.get(
          collectionPath: AppConstants.activeOrderCollectionKey,
          userId: orderId,
        );
        return OrderEntity.fromMap(doc);
      });

  @override
  Future<Result<OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async => executeApi(() async {
    final updatedDoc = await _firebaseStoreServices.updateThenFetch(
      collectionPath: AppConstants.activeOrderCollectionKey,
      docID: orderId,
      data: {AppConstants.activeOrderStatusKey: status.name},
    );

    return OrderEntity.fromMap(updatedDoc);
  });
}
