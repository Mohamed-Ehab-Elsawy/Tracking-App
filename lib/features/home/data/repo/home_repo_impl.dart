import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/data/data_source/firebase_data_source.dart';
import 'package:tracking_app/features/home/data/data_source/home_data_source.dart';
import 'package:tracking_app/features/home/data/mapper/home_orders_mapper.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/home/data/models/home_response_dto.dart';
import 'package:tracking_app/features/home/data/models/update_order_dto.dart';
import 'package:tracking_app/features/home/data/models/update_order_response.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';
import '../../domain/entities/user_entity.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeDataSource _homeDataSource;
  final FirebaseFirestore _firestore;
  final FirebaseOrderDataSource firebaseOrderDataSource;

  const HomeRepoImpl(
    this._homeDataSource,
    this._firestore,
    this.firebaseOrderDataSource,
  );
  @override
  Future<Result<List<HomeOrderEntity>>> getOrders(int page, int limit) async {
    final response = await _homeDataSource.getOrders(page, limit);

    switch (response) {
      case Success<HomeResponseDto>():
        var result =
            response.data.orders
                ?.map((e) => e.toEntity())
                .toList()
                .reversed
                .toList()
                .reversed
                .toList() ??
            [];
        return Success(result);
      case Failure<HomeResponseDto>():
        return Failure(response.errorMessage);
    }
  }

  @override
  Future<Result<OrdersEntity>> acceptOrder({required String orderId}) async {
    final response = await _homeDataSource.acceptOrder(orderId);

    switch (response) {
      case Success<UpdateOrderResponse>():
        {
          var orderDto = response.data.orders ?? UpdateOrdersDto();
          OrdersEntity orderEntity = orderDto.toEntity();

          return Success<OrdersEntity>(orderEntity);
        }
      case Failure<UpdateOrderResponse>():
        return Failure<OrdersEntity>(response.errorMessage);
    }
  }

  @override
  Future<Result<UserEntity>> getUserDetails({String? userId}) async {
    try {
      final dto = await firebaseOrderDataSource.getUserDetails(userId ?? "");

      final entity = dto.toEntity();

      // switch(dto){
      //   case Success<FirebaseUserDto>():
      //     {
      //       return Success(entity);
      //     }
      //   case Failure<FirebaseUserDto>():
      //     {
      //       return Failure(dto.errorMessage);
      //     }
      //
      // }
      return Success(entity);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<ActiveOrderEntity>> saveAcceptedOrder({
    required String userId,
    required String userToken,
    required String driverId,
    required String driverToken,
    required String orderId,
    required HomeOrderEntity orderEntity,
  }) async {
    final response = await firebaseOrderDataSource.saveAcceptedOrder(
      userId: userId,
      userToken: userToken,
      driverId: driverId,
      driverToken: driverToken,
      orderId: orderId,
      orderEntity: orderEntity,
    );

    switch (response) {
      case Success<ActiveOrderDto>():
        {
          var orderDto = response.data;
          ActiveOrderEntity orderEntity = orderDto.toEntity();

          return Success<ActiveOrderEntity>(orderEntity);
        }
      case Failure<ActiveOrderDto>():
        return Failure<ActiveOrderEntity>(response.errorMessage);
    }
  }
}
