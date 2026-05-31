import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/features/home/domain/entities/active_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/order_entity.dart';
import 'package:tracking_app/features/home/domain/entities/user_entity.dart';
import 'package:tracking_app/features/home/domain/use_case/accept_order_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/get_orders_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/get_user_data_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/save_accepted_order_use_case.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';

@injectable
class OrdersViewModel
    extends BaseCubit<OrdersState, OrdersIntent, OrdersEvent> {
  final GetOrdersUseCase _getOrdersUseCase;
  final AcceptOrderUseCase _acceptOrderUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final SaveAcceptedOrderUseCase _saveAcceptedOrderUseCase;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  OrdersViewModel(
    this._getOrdersUseCase,
    this._acceptOrderUseCase,
    this._saveAcceptedOrderUseCase,
    this._getUserDataUseCase,
  ) : super(OrdersState(ordersState: BaseState.init()));
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
        return _handleAcceptOrder(intent.orderId);
      case GetUserDataIntent():
        return _getUserData(intent.orderId);
    }
  }

  //=============================================================
  Future<void> _fetchOrders({required bool refresh}) async {
    if (_isLoadingMore) return;

    if (!refresh) {
      if (!_hasMore) return;
      _isLoadingMore = true;
    }

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      emit(state.copyWith(ordersState: BaseState.loading()));
    }

    final result = await _getOrdersUseCase.invoke(_currentPage, _limit);

    switch (result) {
      case Success<List<HomeOrderEntity>>():
        final currentOrders = state.orders?.data ?? [];
        final newOrdersList = refresh
            ? result.data
            : [...currentOrders, ...result.data];

        _hasMore = result.data.length >= _limit;
        _currentPage++;

        emit(
          state.copyWith(
            orders: BaseState.loaded(newOrdersList),
            hasMore: _hasMore,
            ordersState: BaseState(requestState: RequestState.loaded),
          ),
        );

      case Failure<List<HomeOrderEntity>>():
        emit(state.copyWith(ordersState: BaseState.error(result.errorMessage)));
    }

    _isLoadingMore = false;
  }
  //=============================================================

  Future<void> _handleRejectOrder(String orderId) async {
    final currentOrders = List<HomeOrderEntity>.from(state.orders?.data ?? []);

    currentOrders.removeWhere((order) => order.orderId == orderId);

    emit(
      state.copyWith(
        orders: BaseState.loaded(currentOrders),
        ordersState: BaseState.loaded(currentOrders),
      ),
    );

    emitEvent(RejectOrderEvent(orderId: orderId));
  }
  //=============================================================

  Future<void> _handleAcceptOrder(String orderId) async {
    emit(state.copyWith(ordersState: BaseState.loading()));
    final orders = state.orders?.data ?? [];
    final order = orders.firstWhere((o) => o.orderId == orderId);
    await AppLocalStorage.setSecuredString(
      key: AppConstants.orderId,
      value: order.orderId!,
    );
    if (order.userId == null) {
      emitEvent(
        ShowSnackBarEvent(message: "Order or User ID not found", isError: true),
      );
      return;
    }

    final result = await _acceptOrderUseCase.invoke(orderId: orderId);

    switch (result) {
      case Success<OrdersEntity>():
        {
          final updatedOrders = List<HomeOrderEntity>.from(
            state.orders?.data ?? [],
          );
          updatedOrders.removeWhere((o) => o.orderId == orderId);
          await AppLocalStorage.setSecuredString(
            key: AppConstants.userId,
            value: order.userId!,
          );

          emit(
            state.copyWith(
              orders: BaseState.loaded(updatedOrders),
              ordersState: BaseState.loaded(updatedOrders),
              order: BaseState.loaded(order),
            ),
          );
          await _getUserData(order.userId!);
        }
      case Failure<OrdersEntity>():
        {
          state.copyWith(ordersState: BaseState.error(result.errorMessage));
          emitEvent(
            ShowSnackBarEvent(message: result.errorMessage, isError: true),
          );
        }
    }
  }

  Future<void> _getUserData(String userId) async {
    emit(state.copyWith(userState: BaseState.loading()));

    var result = await _getUserDataUseCase.call(userId);

    switch (result) {
      case Success<UserEntity>():
        {
          final user = result.data;

          emit(state.copyWith(userState: BaseState.loaded(user)));

          await _saveAcceptedOrder(user);
        }

      case Failure<UserEntity>():
        {
          emit(state.copyWith(userState: BaseState.error(result.errorMessage)));
        }
    }
  }

  Future<void> _saveAcceptedOrder(UserEntity user) async {
    emit(state.copyWith(saveAcceptedOrderState: BaseState.loading()));

    final userId = user.userId;
    final userToken = user.token;

    final orderId = state.order?.data?.orderId ?? "";
    final orderEntity = state.order?.data ?? HomeOrderEntity();
    final String driverToken = await AppLocalStorage.getSecuredString(
      key: AppConstants.deviceToken,
    );
    final String driverId = await AppLocalStorage.getSecuredString(
      key: AppConstants.driverId,
    );

    var result = await _saveAcceptedOrderUseCase.call(
      userId: userId,
      userToken: userToken,
      driverId: driverId,
      orderId: orderId,
      orderEntity: orderEntity,
      driverToken: driverToken,
    );

    switch (result) {
      case Success<ActiveOrderEntity>():
        emit(
          state.copyWith(saveAcceptedOrderState: BaseState.loaded(result.data)),
        );

        emitEvent(AcceptOrderEvent(orderId: orderId));
        emitEvent(NavigateToOrderDetailsEvent(orderId: orderId));

      case Failure<ActiveOrderEntity>():
        emit(
          state.copyWith(
            saveAcceptedOrderState: BaseState.error(result.errorMessage),
          ),
        );

        emitEvent(
          ShowSnackBarEvent(message: result.errorMessage, isError: true),
        );
    }
  }
}
