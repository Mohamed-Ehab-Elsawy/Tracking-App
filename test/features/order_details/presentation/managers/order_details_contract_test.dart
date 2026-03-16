import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';

void main() {
  group('OrderDetailsState Tests', () {
    test('initial() should return state with init status and step 0', () {
      final state = CurrentOrderDetailsState.initial();

      expect(state.currentState.requestState, RequestState.init);
      expect(state.currentStep, 0);
    });

    test('copyWith should update currentState when provided', () {
      final initialState = CurrentOrderDetailsState.initial();
      final newState = initialState.copyWith(currentState: BaseState.loading());

      expect(newState.currentState.isLoading, isTrue);
      expect(newState.currentStep, initialState.currentStep);
    });

    test('copyWith should update currentStep when provided', () {
      final initialState = CurrentOrderDetailsState.initial();
      final newState = initialState.copyWith(currentStep: 3);

      expect(newState.currentStep, 3);
      expect(newState.currentState, initialState.currentState);
    });

    test(
      'copyWith should return same values if no parameters are provided',
      () {
        final initialState = CurrentOrderDetailsState.initial();
        final newState = initialState.copyWith();

        expect(newState.currentStep, initialState.currentStep);
        expect(newState.currentState, initialState.currentState);
      },
    );
  });

  group('OrderDetailsIntent Tests', () {
    test('GetOrderDetailsIntent can be instantiated', () {
      final intent = GetCurrentOrderDetailsIntent();
      expect(intent, isA<GetCurrentOrderDetailsIntent>());
    });

    test('ChangeStepIntent can be instantiated', () {
      final intent = ChangeStepIntent();
      expect(intent, isA<ChangeStepIntent>());
    });

    test('PhoneCallPressedIntent stores phone number correctly', () {
      const phone = "123456789";
      final intent = PhoneCallPressedIntent(phone);
      expect(intent.phoneNumber, phone);
    });

    test('WhatsAppPressedIntent stores phone number correctly', () {
      const phone = "987654321";
      final intent = WhatsAppPressedIntent(phone);
      expect(intent.phoneNumber, phone);
    });
  });
}
