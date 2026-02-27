import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';

void main() {
  group('LoginViewState', () {
    test('init() should return a state with BaseState.init()', () {
      final state = LoginViewState.init();
      expect(state.loginState, equals(BaseState.init()));
    });

    test('copyWith should return new instance with updated state', () {
      final initialState = LoginViewState.init();
      final newState = BaseState<String>.loading();

      final updatedState = initialState.copyWith(loginState: newState);

      expect(updatedState.loginState, equals(newState));
      // Ensure it's a new instance but equality works
      expect(updatedState, isNot(same(initialState)));
    });

    test('Equality: identical states should be equal', () {
      final state1 = LoginViewState(BaseState.loaded('done'));
      final state2 = LoginViewState(BaseState.loaded('done'));

      expect(state1, equals(state2));
    });
  });

  group('LoginViewIntent', () {
    test('DriverLoginIntent equality check', () {
      final intent1 = DriverLoginIntent(
        email: 'test@test.com',
        password: '123',
        rememberMe: true,
      );
      final intent2 = DriverLoginIntent(
        email: 'test@test.com',
        password: '123',
        rememberMe: true,
      );

      expect(intent1, equals(intent2));
    });
  });

  group('LoginViewEvent', () {
    test('LoginFailureEvent should be equal if error messages match', () {
      final event1 = LoginFailureEvent(errorMessage: 'Error');
      final event2 = LoginFailureEvent(errorMessage: 'Error');
      final event3 = LoginFailureEvent(errorMessage: 'Different');

      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });

    test(
      'Equality: identical LoginNavToForgetPasswordEvent should be equal',
      () {
        final state1 = LoginNavToForgetPasswordEvent();
        final state2 = LoginNavToForgetPasswordEvent();

        expect(state1, equals(state2));
      },
    );

    test('Equality: identical LoginNavToHomeEvent should be equal', () {
      final state1 = LoginNavToHomeEvent();
      final state2 = LoginNavToHomeEvent();

      expect(state1, equals(state2));
    });
  });
}
