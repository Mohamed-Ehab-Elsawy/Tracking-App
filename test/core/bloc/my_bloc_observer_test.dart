import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/bloc/my_bloc_observer.dart';

void main() {
  late RecordingObserver observer;

  setUp(() {
    observer = RecordingObserver();
    Bloc.observer = observer;
  });

  tearDown(() {
    Bloc.observer = MyBlocObserver();
  });

  group('Cubit lifecycle', () {
    test('onCreate is called on cubit creation', () async {
      final c = TestCubit();
      await pump();
      expect(
        observer.calls.firstWhere((e) => e.startsWith('onCreate:')),
        'onCreate:TestCubit',
      );
      await c.close();
    });

    test('onChange is called on state change', () async {
      final c = TestCubit();
      c.increment();
      await pump();
      expect(observer.calls.any((e) => e == 'onChange:TestCubit:0->1'), isTrue);
      await c.close();
    });

    test('onChange is called multiple times for multiple emits', () async {
      final c = TestCubit();
      c.increment();
      c.incrementBy(2);
      await pump();
      final first = observer.calls
          .where((e) => e == 'onChange:TestCubit:0->1')
          .length;
      final second = observer.calls
          .where((e) => e == 'onChange:TestCubit:1->3')
          .length;
      expect(first, 1);
      expect(second, 1);
      await c.close();
    });

    test('onClose is called on close', () async {
      final c = TestCubit();
      await c.close();
      await pump();
      expect(observer.calls.last, 'onClose:TestCubit');
    });
  });

  group('Bloc lifecycle', () {
    test('onCreate is called on bloc creation', () async {
      final b = TestBloc();
      await pump();
      expect(
        observer.calls.firstWhere((e) => e.startsWith('onCreate:')),
        'onCreate:TestBloc',
      );
      await b.close();
    });

    test('onChange is called on state change via event', () async {
      final b = TestBloc();
      b.add(CounterEvent.inc);
      await pump();
      expect(observer.calls.any((e) => e == 'onChange:TestBloc:0->1'), isTrue);
      await b.close();
    });

    test('onChange reflects successive transitions', () async {
      final b = TestBloc();
      b.add(CounterEvent.inc);
      b.add(CounterEvent.add2);
      await pump();
      final first = observer.calls
          .where((e) => e == 'onChange:TestBloc:0->1')
          .length;
      final second = observer.calls
          .where((e) => e == 'onChange:TestBloc:1->3')
          .length;
      expect(first, 1);
      expect(second, 1);
      await b.close();
    });

    test('onClose is called on close', () async {
      final b = TestBloc();
      await b.close();
      await pump();
      expect(observer.calls.last, 'onClose:TestBloc');
    });
  });
}

class RecordingObserver extends MyBlocObserver {
  final List<String> calls = [];

  @override
  void onCreate(BlocBase bloc) {
    calls.add('onCreate:${bloc.runtimeType}');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    calls.add(
      'onChange:${bloc.runtimeType}:${change.currentState}->${change.nextState}',
    );
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    calls.add('onError:${bloc.runtimeType}:$error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    calls.add('onClose:${bloc.runtimeType}');
    super.onClose(bloc);
  }
}

class TestCubit extends Cubit<int> {
  TestCubit() : super(0);

  void increment() => emit(state + 1);

  void incrementBy(int v) => emit(state + v);
}

enum CounterEvent { inc, add2 }

class TestBloc extends Bloc<CounterEvent, int> {
  TestBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      if (event == CounterEvent.inc) emit(state + 1);
      if (event == CounterEvent.add2) emit(state + 2);
    });
  }
}

Future<void> pump() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
