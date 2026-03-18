import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/home/data/models/firebase_user_dto.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';

import 'firebase_data_source.dart';

@LazySingleton(as: FirebaseOrderDataSource)
class FirebaseOrderDataSourceImpl implements FirebaseOrderDataSource {
  final FirebaseFirestore _firestore;

  FirebaseOrderDataSourceImpl(this._firestore);

  @override
  Future<Result<ActiveOrderDto>> saveAcceptedOrder({
    required String userToken,
    required String driverToken,
    required String orderId,
    required String userId,
    required String driverId,


    required HomeOrderEntity orderEntity,
  }) async {
    final data = {
      "userToken": userToken,
      "driverToken": driverToken,
      "userId": userId,
      "driverId": driverId,
      "orderId": orderEntity.orderId,
      "storeName": orderEntity.storeName,
      "storeAddress": orderEntity.storeAddress,
      "storeImage": orderEntity.storeImage,
      "storeLatLong": orderEntity.storeLatLong,
      "storePhoneNumber": orderEntity.storePhoneNumber,
      "userName": orderEntity.userName,
      "userImage": orderEntity.userImage,
      "userAddress": orderEntity.userAddress,
      "totalPrice": orderEntity.totalPrice,
      "status": OrderStatus.values[0].name.toString(),
      "street": orderEntity.street,
      "city": orderEntity.city,
      "phone": orderEntity.phone,
      "lat": orderEntity.lat,
      "long": orderEntity.long,
      "details": orderEntity.details
          .map(
            (e) => {
              "id": e.id,
              "title": e.title,
              "price": e.price,
              "count": e.count,
            },
          )
          .toList(),
      "startedAt": FieldValue.serverTimestamp(),
    };

    await _firestore.collection("active_orders").doc(orderId).set(data);

    final dtoData = Map<String, dynamic>.from(data);
    dtoData["startedAt"] = DateTime.now().toIso8601String();

    return Success(ActiveOrderDto.fromJson(dtoData));
  }

  @override
  Future<FirebaseUserDto> getUserDetails(String userId) async {
    final doc = await _firestore.collection("users").doc(userId).get();

    if (!doc.exists || doc.data() == null) return FirebaseUserDto();

    return FirebaseUserDto.fromJson(doc.data()!);
  }
}
