import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/domain/use_case/accept_order_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/get_orders_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/get_user_data_use_case.dart';
import 'package:tracking_app/features/home/domain/use_case/save_accepted_order_use_case.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';

import 'orders_view_model_test.mocks.dart';

@GenerateMocks([
  GetOrdersUseCase,
  AcceptOrderUseCase,
  GetUserDataUseCase,
  SaveAcceptedOrderUseCase,
])
void main() {
  late MockGetOrdersUseCase mockUseCase;
  late OrdersViewModel viewModel;
  late MockGetOrdersUseCase getOrdersUseCase;
  late MockAcceptOrderUseCase acceptOrderUseCase;
  late MockGetUserDataUseCase getUserDataUseCase;
  late MockSaveAcceptedOrderUseCase saveAcceptedOrderUseCase;

  setUp(() {
    mockUseCase = MockGetOrdersUseCase();
    acceptOrderUseCase = MockAcceptOrderUseCase();
    getUserDataUseCase = MockGetUserDataUseCase();
    saveAcceptedOrderUseCase = MockSaveAcceptedOrderUseCase();
    getOrdersUseCase = MockGetOrdersUseCase();

    viewModel = OrdersViewModel(
      mockUseCase,
      acceptOrderUseCase,
      saveAcceptedOrderUseCase,
      getUserDataUseCase,
    );
    provideDummy<Result<List<HomeOrderEntity>>>(Success([]));
  });

  final tOrders = [
    HomeOrderEntity(
      orderId: '1',
      userName: 'Ahmed',
      storeName: '',
      storeAddress: '',
      storeImage: '',
      totalPrice: 100.0,
      userImage: '',
      status: '',
      userAddress: '',
    ),
  ];

  group('OrdersViewModel Tests', () {
    blocTest<OrdersViewModel, OrdersState>(
      'emits [loading, loaded] when GetOrdersIntent is successful',
      build: () {
        when(
          mockUseCase.invoke(any, any),
        ).thenAnswer((_) async => Success(tOrders));
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(GetOrdersIntent()),
      expect: () => [
        predicate<OrdersState>((state) => state.ordersState!.isLoading),

        predicate<OrdersState>((state) {
          return state.ordersState!.isLoaded &&
              state.orders?.data?.length == 1 &&
              state.orders?.data?[0].orderId == '1';
        }),
      ],
      verify: (_) {
        verify(mockUseCase.invoke(1, 10)).called(1);
      },
    );

    blocTest<OrdersViewModel, OrdersState>(
      'emits [loading, error] when GetOrdersIntent fails',
      build: () {
        when(
          mockUseCase.invoke(any, any),
        ).thenAnswer((_) async => Failure('Server Error'));
        return viewModel;
      },
      act: (cubit) => cubit.doIntent(GetOrdersIntent()),
      expect: () => [
        predicate<OrdersState>((state) => state.ordersState!.isLoading),
        predicate<OrdersState>(
          (state) =>
              state.ordersState!.isError &&
              state.ordersState!.errorMessage == 'Server Error',
        ),
      ],
    );

    blocTest<OrdersViewModel, OrdersState>(
      'removes order from list and emits RejectOrderEvent when RejectOrderIntent is called',
      seed: () => OrdersState(
        ordersState: BaseState.loaded(tOrders),
        order: BaseState.loaded(tOrders.first),
      ),
      build: () => viewModel,
      act: (cubit) => cubit.doIntent(RejectOrderIntent(orderId: '1')),
      expect: () => [
        predicate<OrdersState>((state) => state.orders?.data?.isEmpty ?? false),
      ],
    );
  });
}
