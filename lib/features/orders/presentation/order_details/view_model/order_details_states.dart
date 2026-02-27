import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';

class OrderDetailsStates extends Equatable {
  final BaseState<Map<String, ProductEntity>>? orderNames;
  const OrderDetailsStates({this.orderNames});
  OrderDetailsStates copyWith({
    BaseState<Map<String, ProductEntity>>? orderNames,
  }) {
    return OrderDetailsStates(orderNames: orderNames ?? this.orderNames);
  }

  @override
  List<Object?> get props => [orderNames];
}
