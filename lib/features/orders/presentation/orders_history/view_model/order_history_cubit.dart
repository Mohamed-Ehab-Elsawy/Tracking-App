import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_orders_history.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_events.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_states.dart';

@injectable
// ignore: must_be_immutable
class OrderHistoryCubit extends Cubit<OrderHistoryStates> with EquatableMixin {
  final GetOrdersHistoryUseCase _getOrdersHistoryUseCase;
  OrderHistoryCubit(this._getOrdersHistoryUseCase)
    : super(const OrderHistoryStates());
  final StreamController<OrderHistoryUiEvents> _orderHistoryUiEvent =
      StreamController.broadcast();

  Stream<OrderHistoryUiEvents> get orderHistoryUiEvent =>
      _orderHistoryUiEvent.stream;

  @override
  List<Object> get props {
    return [state];
  }

  Future<void> doIntent(OrderHistoryEvents event) async {
    switch (event) {
      case GetOrdersHistoryEvents():
        await _getOrdersHistory();
    }
  }

  void doEvent(OrderHistoryUiEvents event) {
    switch (event) {
      case NavigateToOrderDetails():
        _orderHistoryUiEvent.add(NavigateToOrderDetails(order: event.order));
    }
  }

  Future<void> _getOrdersHistory() async {
    emit(
      state.copyWith(
        ordersList: const BaseState(requestState: RequestState.loading),
      ),
    );

    final Result<List<OrdersListEntity>> response =
        await _getOrdersHistoryUseCase.call();

    switch (response) {
      case Success<List<OrdersListEntity>>():
        final orders = response.data;

        final completedCount = orders
            .where((e) => e.order?.state == "completed")
            .length;

        final canceledCount = orders
            .where((e) => e.order?.state == "canceled")
            .length;

        emit(
          state.copyWith(
            ordersList: BaseState<List<OrdersListEntity>>.loaded(orders),
            completedCount: completedCount,
            canceledCount: canceledCount,
          ),
        );

      case Failure<List<OrdersListEntity>>():
        emit(
          state.copyWith(
            ordersList: BaseState<List<OrdersListEntity>>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _orderHistoryUiEvent.close();
    return super.close();
  }
}
