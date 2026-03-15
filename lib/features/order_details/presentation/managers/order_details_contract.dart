import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';

class CurrentOrderDetailsState {
  final BaseState<OrderEntity> currentState;
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
    BaseState<OrderEntity>? state,
    int? currentStep,
    BaseState<void>? sendNotificationState,
    BaseState<NotificationDto>? notificationState,
  }) => CurrentOrderDetailsState(
    state ?? currentState,
    currentStep: currentStep ?? this.currentStep,
    sendNotificationState: this.sendNotificationState,
    notificationState: this.notificationState,
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

class SendOrderStatusNotificationIntent extends CurrentOrderDetailsIntent {
  final String token;
  final String status;

  SendOrderStatusNotificationIntent({
    required this.token,
    required this.status,
  });
}

class SaveNotificationIntent extends CurrentOrderDetailsIntent {
  final NotificationDto notification;
  final String userId;
  SaveNotificationIntent({required this.notification, required this.userId});
}

sealed class CurrentOrderDetailsEvent {}
