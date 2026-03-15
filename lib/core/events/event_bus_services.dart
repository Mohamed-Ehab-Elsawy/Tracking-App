import 'package:event_bus/event_bus.dart';

class EventBusService {
  static final EventBus eventBus = EventBus();
}

class SilentNotificationEvent {}
