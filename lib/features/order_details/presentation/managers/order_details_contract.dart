import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';

class CurrentOrderDetailsState {
  final BaseState<ActiveOrderDto> currentState;
  final BaseState<void> sendNotificationState;
  final BaseState<NotificationDto> notificationState;
  final int currentStep;


  const CurrentOrderDetailsState(
    this.currentState, {
    this.currentStep = 0,
    required this.sendNotificationState,
    required this.notificationState,
  });

  factory CurrentOrderDetailsState.initial() => CurrentOrderDetailsState(
    BaseState.init(),
    currentStep: 0,
    sendNotificationState: BaseState.init(),
    notificationState: BaseState.init(),
  );

  CurrentOrderDetailsState copyWith({
    BaseState<ActiveOrderDto>? currentState,
    int? currentStep,
    BaseState<void>? sendNotificationState,
    BaseState<NotificationDto>? notificationState,
  }) => CurrentOrderDetailsState(
    currentState ?? this.currentState,
    currentStep: currentStep ?? this.currentStep,
    sendNotificationState: this.sendNotificationState,
    notificationState: this.notificationState,
  );
}

sealed class CurrentOrderDetailsIntent {}

class GetCurrentOrderDetailsIntent extends CurrentOrderDetailsIntent {}

class UpdateOrderStatusIntent extends CurrentOrderDetailsIntent {

}


class ChangeStepIntent extends CurrentOrderDetailsIntent {
  final String token;
  final String status;

  ChangeStepIntent({required this.token, required this.status});
}

class PhoneCallPressedIntent extends CurrentOrderDetailsIntent {
  final String phoneNumber;

  PhoneCallPressedIntent(this.phoneNumber);
}

class WhatsAppPressedIntent extends CurrentOrderDetailsIntent {
  final String phoneNumber;

  WhatsAppPressedIntent(this.phoneNumber);
}

class SendNotificationIntent extends CurrentOrderDetailsIntent {
  final String token;
  final String status;

  SendNotificationIntent({required this.token, required this.status});
}

class SaveNotificationIntent extends CurrentOrderDetailsIntent {
  final NotificationDto notification;
  final String userId;

  SaveNotificationIntent({required this.notification, required this.userId});
}

sealed class CurrentOrderDetailsEvent {}

class ReciveNotificationEvent extends CurrentOrderDetailsEvent {}
