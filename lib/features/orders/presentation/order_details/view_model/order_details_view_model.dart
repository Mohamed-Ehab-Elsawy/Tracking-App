import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/orders/domain/entity/product_entity.dart';
import 'package:tracking_app/features/orders/domain/use_cases/get_product_by_id_use_case.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_events.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_states.dart';

@injectable
// ignore: must_be_immutable
class OrderItemNameCubit extends Cubit<OrderDetailsStates> with EquatableMixin {
  final GetProductByIdUseCase _getOrderByIdUseCase;

  OrderItemNameCubit(this._getOrderByIdUseCase)
    : super(const OrderDetailsStates());

  @override
  List<Object> get props => [state];

  Future<void> doIntent(OrderDetailsEvents event) async {
    if (event is GetOrderNamesByIdsEvents) {
      await _getOrderNames(event.ids);
    }
  }

  Future<void> _getOrderNames(List<String> ids) async {
    emit(
      state.copyWith(
        orderNames: const BaseState(requestState: RequestState.loading),
      ),
    );

    final Map<String, ProductEntity> productsMap = {};

    final futures = ids.map((id) => _getOrderByIdUseCase.call(id));

    final results = await Future.wait(futures);

    for (int i = 0; i < ids.length; i++) {
      final result = results[i];
      final key = ids[i];

      switch (result) {
        case Success<ProductEntity>():
          {
            productsMap[key] = ProductEntity(
              id: result.data.id,
              title: result.data.title,
              slug: result.data.slug,
              description: result.data.description,
              imgCover: result.data.imgCover,
              images: result.data.images,
              price: result.data.price,
              priceAfterDiscount: result.data.priceAfterDiscount,
            );
            emit(
              state.copyWith(
                orderNames: BaseState<Map<String, ProductEntity>>.loaded(
                  productsMap,
                ),
              ),
            );
          }
        case Failure<ProductEntity>():
          emit(
            state.copyWith(
              orderNames: BaseState<Map<String, ProductEntity>>.error(
                result.errorMessage,
              ),
            ),
          );
      }
    }
  }
}
