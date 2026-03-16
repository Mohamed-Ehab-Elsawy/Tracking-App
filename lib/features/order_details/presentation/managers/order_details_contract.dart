import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';

class CurrentOrderDetailsState {
  final BaseState<ActiveOrderDto> currentState;
  final int currentStep;

  const CurrentOrderDetailsState(this.currentState, {this.currentStep = 0});

  factory CurrentOrderDetailsState.initial() =>
      CurrentOrderDetailsState(BaseState.init(), currentStep: 0);

  CurrentOrderDetailsState copyWith({
    BaseState<ActiveOrderDto>? currentState,
    int? currentStep,
  }) => CurrentOrderDetailsState(
    currentState ?? this.currentState,
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
