import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/user_entity.dart';

class OrdersState extends Equatable {
  final BaseState? ordersState;
  final BaseState<List<HomeOrderEntity>>? orders;
  final BaseState<HomeOrderEntity>? order;
  final BaseState<ActiveOrderEntity>? saveAcceptedOrderState;

  final bool? hasMore;
  final BaseState<UserEntity>? userState;
  const OrdersState({
    required this.ordersState,
    this.hasMore,
    this.orders,
    this.userState,
    this.order,
    this.saveAcceptedOrderState,
  });

  OrdersState copyWith({
    BaseState<List<HomeOrderEntity>>? orders,
    BaseState<HomeOrderEntity>? order,
    bool? hasMore,
    BaseState? ordersState,
    BaseState<UserEntity>? userState,
    BaseState<ActiveOrderEntity>? saveAcceptedOrderState,
  }) {
    return OrdersState(
      ordersState: ordersState ?? this.ordersState,
      hasMore: hasMore ?? this.hasMore,
      orders: orders ?? this.orders,
      order: order ?? this.order,
      userState: userState ?? this.userState,
      saveAcceptedOrderState:
          saveAcceptedOrderState ?? this.saveAcceptedOrderState,
    );
  }

  @override
  List<Object?> get props => [ordersState, hasMore, order];
}
