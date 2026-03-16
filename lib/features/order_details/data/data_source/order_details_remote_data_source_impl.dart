import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

@Injectable(as: OrderDetailsRemoteDataSource)
class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderDetailsRemoteDataSourceImpl(this._firestore);

  @override
  Future<Result<OrderEntity>> getCurrentOrderDetails(String orderId) async {
    try {
      final doc = await _firestore
          .collection('active_orders')
          .doc(orderId)
          .get();

      if (doc.data() == null) return Failure('not_found');

      return Success(OrderEntity.fromMap(doc.data()!));
    } on FirebaseException catch (e) {
      return Failure(e.message ?? 'something_went_wrong');
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      if (orderId.isEmpty || status.name.isEmpty) {
        return Failure("invalid_params");
      }

      final docRef = _firestore.collection('active_orders').doc(orderId);

      await docRef.update({'status': status.name});

      final updatedDoc = await docRef.get();

      if (updatedDoc.data() == null) {
        return Failure('not_found');
      }

      return Success(OrderEntity.fromMap(updatedDoc.data()!));
    } on FirebaseException catch (e) {
      return Failure(e.message ?? 'something_went_wrong');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
