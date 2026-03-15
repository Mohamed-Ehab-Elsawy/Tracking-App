import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/data_sources/fire_base_order_details_data_source.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final FirebaseFirestore _firestore;
  final FirebaseOrderDetailsDataSource _dataSource;
  OrderDetailsRepoImpl(this._firestore, this._dataSource);

  @override
  Future<Result<OrderEntity>> getCurrentOrderDetails({String? orderId}) async {
    try {
      final id =
          orderId ??
          await AppLocalStorage.getSecuredString(key: AppConstants.orderId);

      ///
      final doc = await _firestore.collection("active_orders").doc(id).get();

      if (doc.data() == null) return Failure('not_found');

      return Success(OrderEntity.fromMap(doc.data()!));
    } on FirebaseException catch (e) {
      return Failure(e.message ?? 'something_went_wrong');
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> sendNotification({
    required SendNotificationRequest notificationDto,
    required String authorization,
  }) {
    return _dataSource.sendNotification(
      notificationDto: notificationDto,
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
}
