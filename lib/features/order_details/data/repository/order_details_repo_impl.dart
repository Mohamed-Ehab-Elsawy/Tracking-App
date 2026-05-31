import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/repository/order_details_repo.dart';

@Injectable(as: OrderDetailsRepo)
class OrderDetailsRepoImpl implements OrderDetailsRepo {
  final FirebaseFirestore _firestore;

  OrderDetailsRepoImpl(this._firestore);

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
}
