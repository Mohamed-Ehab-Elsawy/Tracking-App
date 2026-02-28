import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_events.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_states.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';

import 'order_details_view_model_test.mocks.dart';

@GenerateMocks([GetProductByIdUseCase])
void main() {
  late MockGetProductByIdUseCase useCase;
  late ProductEntity productEntity;

  setUp(() {
    useCase = MockGetProductByIdUseCase();
    productEntity = ProductEntity(id: "1", title: "test");

    provideDummy<Result<ProductEntity>>(Success(productEntity));
  });
  blocTest<OrderItemNameCubit, OrderDetailsStates>(
    ' emits [loading, success] when _getOrderNames returns Success',
    build: () {
      when(
        useCase.call("1"),
      ).thenAnswer((_) async => Success<ProductEntity>(productEntity));
      return OrderItemNameCubit(useCase);
    },
    act: (bloc) => bloc.doIntent(GetOrderNamesByIdsEvents(ids: ["1"])),
    expect: () {
      var state = const OrderDetailsStates(
        orderNames: BaseState<Map<String, ProductEntity>>(
          requestState: RequestState.loading,
        ),
      );

      return [
        state.copyWith(
          orderNames: const BaseState<Map<String, ProductEntity>>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          orderNames: BaseState<Map<String, ProductEntity>>(
            data: {"1": productEntity},
            requestState: RequestState.loaded,
          ),
        ),
      ];
    },
    verify: (_) {
      verify(useCase.call("1")).called(1);
    },
  );
  blocTest<OrderItemNameCubit, OrderDetailsStates>(
    ' emits [loading, error] when _getOrderNames returns Failure',
    build: () {
      when(
        useCase.call("1"),
      ).thenAnswer((_) async => Failure<ProductEntity>("error"));
      return OrderItemNameCubit(useCase);
    },
    act: (bloc) => bloc.doIntent(GetOrderNamesByIdsEvents(ids: ["1"])),
    expect: () {
      var state = const OrderDetailsStates(
        orderNames: BaseState<Map<String, ProductEntity>>(
          requestState: RequestState.loading,
        ),
      );
      return [
        state.copyWith(
          orderNames: const BaseState<Map<String, ProductEntity>>(
            requestState: RequestState.loading,
          ),
        ),

        state.copyWith(
          orderNames: BaseState<Map<String, ProductEntity>>(
            requestState: RequestState.error,
            errorMessage: "error",
          ),
        ),
      ];
    },
  );
}
