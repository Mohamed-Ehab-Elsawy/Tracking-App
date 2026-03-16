import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

class CurrentOrderDetailsState {
  final BaseState<OrderEntity> currentState;
  final int currentStep;

  const CurrentOrderDetailsState(this.currentState, {this.currentStep = 0});

  factory CurrentOrderDetailsState.initial() =>
      CurrentOrderDetailsState(BaseState.init(), currentStep: 0);

  CurrentOrderDetailsState copyWith({
    BaseState<OrderEntity>? state,
    int? currentStep,
  }) => CurrentOrderDetailsState(
    state ?? currentState,
    currentStep: currentStep ?? this.currentStep,
  );
}

sealed class CurrentOrderDetailsIntent {}

class GetCurrentOrderDetailsIntent extends CurrentOrderDetailsIntent {}

class ChangeStepIntent extends CurrentOrderDetailsIntent {}

class PhoneCallPressedIntent extends CurrentOrderDetailsIntent {
  final String phoneNumber;

  PhoneCallPressedIntent(this.phoneNumber);
}

class WhatsAppPressedIntent extends CurrentOrderDetailsIntent {
  final String phoneNumber;

  WhatsAppPressedIntent(this.phoneNumber);
}

sealed class CurrentOrderDetailsEvent {}

class ReciveNotificationEvent extends CurrentOrderDetailsEvent {}
