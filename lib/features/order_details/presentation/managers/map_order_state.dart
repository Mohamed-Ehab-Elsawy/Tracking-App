import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/bloc/base_state.dart';

class MapOrderState {
  final BaseState<List<Position>> directions;
  final BaseState<void>? phoneCall;

  const MapOrderState({required this.directions, this.phoneCall});

  factory MapOrderState.initial() =>
      MapOrderState(directions: BaseState.init());

  MapOrderState copyWith({
    BaseState<List<Position>>? directions,
    BaseState<void>? phoneCall,
  }) => MapOrderState(
    directions: directions ?? this.directions,
    phoneCall: phoneCall ?? this.phoneCall,
  );
}

sealed class MapOrderIntent {}

class GetDirectionsIntent extends MapOrderIntent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  GetDirectionsIntent({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });
}

class PhoneCallPressedIntent extends MapOrderIntent {
  final String phoneNumber;

  PhoneCallPressedIntent(this.phoneNumber);
}

class WhatsAppPressedIntent extends MapOrderIntent {
  final String phoneNumber;

  WhatsAppPressedIntent(this.phoneNumber);
}

sealed class MapOrderEvent {}

class MapOrderErrorEvent extends MapOrderEvent {
  final String errorMessage;
  MapOrderErrorEvent(this.errorMessage);
}
