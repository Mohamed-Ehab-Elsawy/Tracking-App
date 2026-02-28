import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/data/models/response/orders_list_dto.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_orders_history.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_events.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_states.dart';

import 'order_history_cubit_test.mocks.dart';

@GenerateMocks([GetOrdersHistoryUseCase])
void main() {
  late MockGetOrdersHistoryUseCase mockGetOrdersHistoryUseCase;
  late OrdersListEntity ordersListEntity;
  late OrdersListEntity ordersListEntity2;
  late List<OrdersListEntity> list;
  setUp(() {
    mockGetOrdersHistoryUseCase = MockGetOrdersHistoryUseCase();
    ordersListEntity = OrdersListEntity(
      id: "1",
      order: OrderDto(state: "completed"),
    );
    ordersListEntity2 = OrdersListEntity(
      id: "1",
      order: OrderDto(state: "canceled"),
    );
    list = [ordersListEntity, ordersListEntity2];

    provideDummy<Result<List<OrdersListEntity>>>(
      Success([ordersListEntity, ordersListEntity]),
    );
  });
  blocTest<OrderHistoryCubit, OrderHistoryStates>(
    ' emits [loading, success] when _getOrdersHistory returns Success',
    build: () {
      when(
        mockGetOrdersHistoryUseCase.call(),
      ).thenAnswer((_) async => Success<List<OrdersListEntity>>(list));
      return OrderHistoryCubit(mockGetOrdersHistoryUseCase);
    },
    act: (bloc) => bloc.doIntent(GetOrdersHistoryEvents(ordersList: list)),
    expect: () {
      var state = const OrderHistoryStates(
        ordersList: BaseState<List<OrdersListEntity>>(
          requestState: RequestState.loading,
        ),
      );

      return [
        state.copyWith(
          ordersList: const BaseState<List<OrdersListEntity>>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          ordersList: BaseState<List<OrdersListEntity>>(
            data: list,
            requestState: RequestState.loaded,
          ),
          completedCount: 1,
          canceledCount: 1,
        ),
      ];
    },
    verify: (_) {
      verify(mockGetOrdersHistoryUseCase.call()).called(1);
    },
  );
  blocTest<OrderHistoryCubit, OrderHistoryStates>(
    ' emits [loading, error] when _getOrdersHistory returns Failure',
    build: () {
      when(
        mockGetOrdersHistoryUseCase.call(),
      ).thenAnswer((_) async => Failure<List<OrdersListEntity>>("error"));
      return OrderHistoryCubit(mockGetOrdersHistoryUseCase);
    },
    act: (bloc) => bloc.doIntent(GetOrdersHistoryEvents(ordersList: list)),
    expect: () {
      var state = const OrderHistoryStates(
        ordersList: BaseState<List<OrdersListEntity>>(
          requestState: RequestState.loading,
        ),
      );
      return [
        state.copyWith(
          ordersList: const BaseState<List<OrdersListEntity>>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          ordersList: BaseState<List<OrdersListEntity>>(
            requestState: RequestState.error,
            errorMessage: "error",
          ),
        ),
      ];
    },
  );
}
