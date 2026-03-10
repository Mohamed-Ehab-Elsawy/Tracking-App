import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_current_order_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
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

  CurrentOrderDetailsCubit(this._getCurrentOrderUseCase)
    : super(CurrentOrderDetailsState.initial());

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
        final nextStep = (state.currentStep + 1) % 5;
        emit(state.copyWith(currentStep: nextStep));
    }
  }

  void _getOrderDetails() async {
    emit(state.copyWith(state: BaseState.loading()));
    var result = await _getCurrentOrderUseCase.call();
    switch (result) {
      case Success<OrderEntity>():
        {
          emit(state.copyWith(state: BaseState.loaded(result.data)));
        }

      case Failure<OrderEntity>():
        {
          emit(state.copyWith(state: BaseState.error(result.errorMessage)));
        }
    }
  }

  Future<void> _openDialer(String phoneNumber) async {
    final uri = Uri.parse("tel:$phoneNumber");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll('+', '').replaceAll(' ', '');

    final uri = Uri.parse("https://wa.me/$cleaned");

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
