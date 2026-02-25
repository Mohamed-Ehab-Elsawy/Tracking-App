import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

class OrderDetailsState {
  final BaseState<OrderEntity> currentState;
  final int currentStep;

  const OrderDetailsState(this.currentState, {this.currentStep = 0});

  factory OrderDetailsState.initial() =>
      OrderDetailsState(BaseState.init(), currentStep: 0);

  OrderDetailsState copyWith({
    BaseState<OrderEntity>? state,
    int? currentStep,
  }) => OrderDetailsState(
    state ?? currentState,
    currentStep: currentStep ?? this.currentStep,
  );
}

sealed class OrderDetailsIntent {}

class GetOrderDetailsIntent extends OrderDetailsIntent {}

class ChangeStepIntent extends OrderDetailsIntent {}

class PhoneCallPressedIntent extends OrderDetailsIntent {
  final String phoneNumber;

  PhoneCallPressedIntent(this.phoneNumber);
}

class WhatsAppPressedIntent extends OrderDetailsIntent {
  final String phoneNumber;

  WhatsAppPressedIntent(this.phoneNumber);
}

sealed class OrderDetailsEvent {}
