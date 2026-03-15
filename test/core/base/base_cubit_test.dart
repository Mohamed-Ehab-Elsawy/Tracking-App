import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_cubit.dart';

enum TestIntent { increment }

enum TestEvent { navigate }

class TestCubit extends BaseCubit<int, TestIntent, TestEvent> {
  TestCubit() : super(0);

  @override
  Future<void> doIntent(TestIntent intent) async {
    if (intent == TestIntent.increment) {
      emit(state + 1);
      emitEvent(TestEvent.navigate);
    }
  }
}

void main() {
  group('BaseCubit', () {
    late TestCubit cubit;

    setUp(() {
      cubit = TestCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is correct', () {
      expect(cubit.state, 0);
    });

    blocTest<TestCubit, int>(
      'emits new state when intent is handled',
      build: () => TestCubit(),
      act: (cubit) => cubit.doIntent(TestIntent.increment),
      expect: () => [1],
    );

    test('emits events to eventStream', () async {
      final events = <TestEvent>[];

      final sub = cubit.eventStream.listen(events.add);

      await cubit.doIntent(TestIntent.increment);

      expect(events, [TestEvent.navigate]);

      await sub.cancel();
    });

    test('eventStream is broadcast (multiple listeners)', () async {
      final events1 = <TestEvent>[];
      final events2 = <TestEvent>[];

      final sub1 = cubit.eventStream.listen(events1.add);
      final sub2 = cubit.eventStream.listen(events2.add);

      cubit.emitEvent(TestEvent.navigate);

      await Future.microtask(() {});

      expect(events1, [TestEvent.navigate]);
      expect(events2, [TestEvent.navigate]);

      await sub1.cancel();
      await sub2.cancel();
    });

    test('does not throw when emitting events after close', () async {
      await cubit.close();

      expect(() => cubit.emitEvent(TestEvent.navigate), returnsNormally);
    });

    test('eventStream completes on close', () async {
      var isDone = false;

      cubit.eventStream.listen((_) {}, onDone: () => isDone = true);

      await cubit.close();

      expect(isDone, true);
    });
  });
}
