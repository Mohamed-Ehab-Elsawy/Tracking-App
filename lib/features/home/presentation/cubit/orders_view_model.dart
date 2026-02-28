import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/use_case/get_orders_use_case.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';

@injectable
class OrdersViewModel
    extends BaseCubit<OrdersState, OrdersIntent, OrdersEvent> {
  final GetOrdersUseCase _getOrdersUseCase;
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  OrdersViewModel(this._getOrdersUseCase)
    : super(OrdersState(ordersState: BaseState.init()));
  @override
  Future<void> doIntent(OrdersIntent intent) {
    switch (intent) {
      case GetOrdersIntent():
        return _fetchOrders(refresh: true);
      case RefreshOrdersIntent():
        return _fetchOrders(refresh: true);
      case LoadMoreOrdersIntent():
        return _fetchOrders(refresh: false);
      case RejectOrderIntent():
        _handleRejectOrder(intent.orderId);
        return Future.value();
      case AcceptOrderIntent():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<void> _fetchOrders({required bool refresh}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      emit(state.copyWith(ordersState: BaseState.loading()));
    } else {
      if (!_hasMore) return;
      emit(state.copyWith(ordersState: BaseState.loading()));
    }

    final result = await _getOrdersUseCase.invoke(_currentPage, _limit);

    switch (result) {
      case Success<List<HomeOrderEntity>>():
        final currentOrders = (state.order?.data ?? []);
        final newOrdersList = refresh
            ? result.data
            : currentOrders + result.data;
        _hasMore = result.data.length >= _limit;
        _currentPage++;
        emit(
          state.copyWith(
            order: BaseState.loaded(newOrdersList),
            hasMore: _hasMore,
            ordersState: BaseState(requestState: RequestState.loaded),
          ),
        );
      case Failure<List<HomeOrderEntity>>():
        emit(state.copyWith(ordersState: BaseState.error(result.errorMessage)));
    }
  }

  Future<void> _handleRejectOrder(String orderId) async {
    final currentOrders = List<HomeOrderEntity>.from(state.order?.data ?? []);

    currentOrders.removeWhere((order) => order.orderId == orderId);

    emit(
      state.copyWith(
        order: BaseState.loaded(currentOrders),
        ordersState: BaseState.loaded(currentOrders),
      ),
    );

    emitEvent(RejectOrderEvent(orderId: orderId));
  }
}
