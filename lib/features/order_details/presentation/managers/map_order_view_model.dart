import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/base/base_cubit.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/core/services/map_service.dart';
import 'package:tracking_app/core/services/phone_service.dart';
import 'package:tracking_app/features/order_details/domain/use_case/get_directions_use_case.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_state.dart';

@injectable
class MapOrderViewModel
    extends BaseCubit<MapOrderState, MapOrderIntent, MapOrderEvent> {
  final GetDirectionsUseCase _getDirectionsUseCase;
  final MapService _mapService;
  final PhoneService _phoneService;

  MapOrderViewModel(
    this._getDirectionsUseCase,
    this._mapService,
    this._phoneService,
  ) : super(MapOrderState.initial());

  Future<void> _getDirections({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    emit(state.copyWith(directions: BaseState.loading()));
    var result = await _getDirectionsUseCase.call(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    switch (result) {
      case Success<List<Position>>():
        emit(state.copyWith(directions: BaseState.loaded(result.data)));
      case Failure<List<Position>>():
        emitEvent(MapOrderErrorEvent(result.errorMessage));
    }
  }

  void _showRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    bool isUser = true,
  }) async {
    if ((endLat) == 0.0 || (endLng) == 0.0) {
      emitEvent(MapOrderErrorEvent("the directions are not available"));
      return;
    }
    await _getDirections(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );
    final route = state.directions.data ?? [];

    await _mapService.addMarkers(
      startLat,
      startLng,
      endLat,
      endLng,
      isUser: isUser,
    );

    if (route.isNotEmpty) {
      await _mapService.drawRoute(route);
      await _mapService.fitBounds(route);
    }
  }

  Future<void> clearMarkers() async {
    await _mapService.clearMarkers();
  }

  initMap(MapboxMap mapboxMap) async {
    await _mapService.initMap(mapboxMap);
  }

  moveCamera(double lat, double lng, {double zoom = 15}) async {
    await _mapService.moveCamera(lat, lng, zoom: zoom);
  }

  void _call(String phone) async {
    try {
      await _phoneService.call(phone);
    } catch (e) {
      emitEvent(MapOrderErrorEvent(e.toString()));
    }
  }

  _openWhatsApp(String phone, {String message = ''}) async {
    try {
      await _phoneService.openWhatsApp(phone, message: message);
    } catch (e) {
      emitEvent(MapOrderErrorEvent(e.toString()));
    }
  }

  @override
  void doIntent(MapOrderIntent intent) {
    switch (intent) {
      case GetDirectionsIntent():
        // Add this guard before calling
        _showRoute(
          startLat: intent.startLat,
          startLng: intent.startLng,
          endLat: intent.endLat,
          endLng: intent.endLng,
          isUser: intent.isUser,
        );
      case PhoneCallPressedIntent():
        _call(intent.phoneNumber);
      case WhatsAppPressedIntent():
        _openWhatsApp(intent.phoneNumber);
    }
  }
}
