import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/bloc/base_state.dart';

void main() {
  group('BaseState Factory Constructors & Getters', () {
    test('BaseState.init should set correct status and flags', () {
      final state = BaseState<String>.init();

      expect(state.requestState, RequestState.init);
      expect(state.isInitial, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.isLoaded, isFalse);
      expect(state.isError, isFalse);
      expect(state.data, isNull);
    });

    test('BaseState.loading should set loading flag and optional data', () {
      const mockData = "Previous Data";
      final state = BaseState<String>.loading(mockData);

      expect(state.requestState, RequestState.loading);
      expect(state.isLoading, isTrue);
      expect(state.data, mockData);
    });

    test('BaseState.loaded should set data and loaded flag', () {
      const mockData = "Final Data";
      final state = BaseState<String>.loaded(mockData);

      expect(state.requestState, RequestState.loaded);
      expect(state.isLoaded, isTrue);
      expect(state.data, mockData);
      expect(state.errorMessage, isNull);
    });

    test('BaseState.error should set message and error flag', () {
      const errorMsg = "Network Timeout";
      final state = BaseState<String>.error(errorMsg);

      expect(state.requestState, RequestState.error);
      expect(state.isError, isTrue);
      expect(state.errorMessage, errorMsg);
    });
  });

  group('BaseState Equality (Equatable)', () {
    test('Two states with same data should be equal', () {
      final state1 = BaseState.loaded('test');
      final state2 = BaseState.loaded('test');

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('Two states with different status should not be equal', () {
      final state1 = BaseState.loading('test');
      final state2 = BaseState.loaded('test');

      expect(state1, isNot(equals(state2)));
    });

    test('Two error states with different messages should not be equal', () {
      final state1 = BaseState<int>.error('Msg A');
      final state2 = BaseState<int>.error('Msg B');

      expect(state1, isNot(equals(state2)));
    });
  });

  group('BaseStateExtension Tests', () {
    test('Extension methods should return correct state variants', () {
      final initialState = BaseState<int>.init();

      expect(initialState.loading.isLoading, isTrue);
      expect(initialState.loaded(100).data, 100);
      expect(initialState.error('fail').errorMessage, 'fail');
      expect(initialState.error('fail').init.isInitial, isTrue);
    });
  });
}
