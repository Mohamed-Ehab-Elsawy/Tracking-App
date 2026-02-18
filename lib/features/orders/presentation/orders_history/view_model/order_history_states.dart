import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';

class OrderHistoryStates extends Equatable {
  final BaseState<List<OrdersListEntity>>? ordersList;
  final int? completedCount;
  final int? canceledCount;
  const OrderHistoryStates({
    this.ordersList,
    this.completedCount,
    this.canceledCount,
  });
  OrderHistoryStates copyWith({
    BaseState<List<OrdersListEntity>>? ordersList,
    int? completedCount,
    int? canceledCount,
  }) {
    return OrderHistoryStates(
      ordersList: ordersList ?? ordersList,
      completedCount: completedCount ?? this.completedCount,
      canceledCount: canceledCount ?? this.canceledCount,
    );
  }

  @override
  List<Object?> get props => [ordersList, completedCount, canceledCount];
}
