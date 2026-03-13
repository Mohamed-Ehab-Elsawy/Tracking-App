import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';

class OrdersState extends Equatable {
  final BaseState? ordersState;
  final BaseState<List<HomeOrderEntity>>? order;
  final bool? hasMore;

  const OrdersState({required this.ordersState, this.hasMore, this.order});

  OrdersState copyWith({
    BaseState<List<HomeOrderEntity>>? order,
    bool? hasMore,
    BaseState? ordersState,
  }) {
    return OrdersState(
      ordersState: ordersState ?? this.ordersState,
      hasMore: hasMore ?? this.hasMore,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [ordersState, hasMore, order];
}
