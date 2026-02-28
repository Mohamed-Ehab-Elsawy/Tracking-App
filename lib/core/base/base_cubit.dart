import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T, I, E> extends Cubit<T> {
  BaseCubit(super.initialState);

  void doIntent(I intent);

  final StreamController<E> _eventController = StreamController<E>.broadcast();

  Stream<E> get eventStream => _eventController.stream;

  void emitEvent(E event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  @override
  Future<void> close() async {
    await _eventController.close();
    return super.close();
  }
}
