import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/services/notification_dto.dart';
import 'package:tracking_app/features/order_details/data/models/notification_dto.dart';
import 'package:tracking_app/core/events/app_event_bus.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_current_order_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/update_order_status_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/save_notification_to_fire_base_use_case.dart';
import 'package:tracking_app/features/order_details/domain/use_case/send_notification_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_status.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class CurrentOrderDetailsCubit
    extends
        BaseCubit<
          CurrentOrderDetailsState,
          CurrentOrderDetailsIntent,
          CurrentOrderDetailsEvent
        > {
  final GetCurrentOrderUseCase _getCurrentOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final orderStatus = OrderStatus.accepted;
  final SendNotificationUseCase _sendNotificationUseCase;
  final SaveNotificationToFireBaseUseCase _saveNotificationToFireBaseUseCase;

  CurrentOrderDetailsCubit(
    this._getCurrentOrderUseCase,
    this._updateOrderStatusUseCase,
    this._getCurrentOrderUseCase,
    this._sendNotificationUseCase,
    this._saveNotificationToFireBaseUseCase,
  ) : super(CurrentOrderDetailsState.initial());

  @override
  void doIntent(CurrentOrderDetailsIntent intent) {
    switch (intent) {
      case GetCurrentOrderDetailsIntent():
        _getOrderDetails();

      case PhoneCallPressedIntent():
        _openDialer(intent.phoneNumber);

      case WhatsAppPressedIntent():
        _openWhatsApp(intent.phoneNumber);

      case ChangeStepIntent():
        _changeStatus();
      case SendOrderStatusNotificationIntent():
        _sendNotification(intent.token, intent.status);
      case SaveNotificationIntent():
        _saveNotificationToFireBase(intent.userId);
    }
  }

  void _getOrderDetails() async {
    emit(state.copyWith(currentState: BaseState.loading()));
    var result = await _getCurrentOrderUseCase.call();
    switch (result) {
      case Success<OrderEntity>():
        {
          final entity = result.data;
          final currentStep = switch (entity.status) {
            "accepted" => 0,
            "picked" => 1,
            "outForDelivery" => 2,
            "arrived" => 3,
            "delivered" => 4,
            String() => 0,
          };
          emit(
            state.copyWith(
              currentState: BaseState.loaded(entity),
              currentStep: currentStep,
            ),
          );
        }
      case Failure<OrderEntity>():
        {
          emit(
          state.copyWith(currentState: BaseState.error(result.errorMessage)),
        );
    }
  }

  Future<void> _changeStatus() async {
    final nextStep = (state.currentStep + 1) % OrderStatus.values.length;
    final nextStatus = OrderStatus.values[nextStep];

    final result = await _updateOrderStatusUseCase.call(nextStatus);
    switch (result) {
      case Success<OrderEntity>():
        emit(
          state.copyWith(
            currentStep: nextStep,
            currentState: BaseState.loaded(result.data),
          ),
        );
      case Failure<OrderEntity>():
        emit(
          state.copyWith(currentState: BaseState.error(result.errorMessage)),
        );
        }
    }
  }

  Future<void> _sendNotification(String token, String status) async {
    emit(state.copyWith(sendNotificationState: BaseState.loading()));
    final accessToken = await AppLocalStorage.getSecuredString(
      key: AppConstants.fcmAccessToken,
    );
    final notification = SendNotificationRequest(
      token,
      "Order Update",
      "Order status changed to $status",
      {"status": status},
    );

    final result = await _sendNotificationUseCase.call(
      notificationDto: notification,
      authorization: "Bearer $accessToken",
    );

    switch (result) {
      case Success<void>():
        final userId = state.currentState.data?.id;
        if (userId != null) {
          await _saveNotificationToFireBase(userId);
        }
        emit(state.copyWith(state: BaseState.loaded(state.currentState.data)));

      case Failure<void>():
        emit(
          state.copyWith(
            sendNotificationState: BaseState.error(result.errorMessage),
          ),
        );
    }
  }

  Future<void> _openDialer(String phoneNumber) async {
    final uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void listonOnSilentNotificationEvent() {
    EventBusService.eventBus.on<SilentNotificationEvent>().listen((event) {
      emitEvent(ReciveNotificationEvent());
    });
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll('+', '').replaceAll(' ', '');

    final uri = Uri.parse("https://wa.me/$cleaned");

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  //=============================================================

  Future<void> _saveNotificationToFireBase(String userId) async {
    emit(state.copyWith(notificationState: BaseState.loading()));
    final notification = NotificationDto(
      body: state.notificationState.data?.body,
      title: state.notificationState.data?.title,
      status: state.notificationState.data?.status,
    );

    final result = await _saveNotificationToFireBaseUseCase.invoke(
      notification: notification,
      userId: userId,
    );

    switch (result) {
      case Success<void>():
        emit(state.copyWith(notificationState: BaseState.loaded(notification)));
      case Failure<void>():
        emit(
          state.copyWith(
            notificationState: BaseState.error(result.errorMessage),
          ),
        );
    }
  }
}
