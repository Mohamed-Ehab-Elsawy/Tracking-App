import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/home/data/models/firebase_user_dto.dart';

import '../../domain/entities/home_order_entity.dart';

abstract class FirebaseOrderDataSource {
  Future<Result<ActiveOrderDto>> saveAcceptedOrder({
    required String userId,
    required String userToken,
    required String driverId,
    required String driverToken,
    required String orderId,
    required HomeOrderEntity orderEntity,
  });
  Future<FirebaseUserDto> getUserDetails(String userId);
}
