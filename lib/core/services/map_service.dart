import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';

@injectable
class MapService {
  MapboxMap? _map;
  PointAnnotationManager? _markerManager;
  PolylineAnnotationManager? _polylineManager;

  Future<void> initMap(MapboxMap mapboxMap) async {
    _map = mapboxMap;

    _markerManager = await _map!.annotations.createPointAnnotationManager();

    _polylineManager = await _map!.annotations
        .createPolylineAnnotationManager();
  }

  Future<void> moveCamera(double lat, double lng, {double zoom = 15}) async {
    if (_map == null) return;
    await _map!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 2000),
    );
  }

  Future<void> showRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    await clearMarkers();

    await addMarkers(startLat, startLng, endLat, endLng);

    final route = await getRoute(startLat, startLng, endLat, endLng);

    await drawRoute(route);
  }

  Future<void> drawRoute(List<Position> points) async {
    if (_polylineManager == null) return;

    await _polylineManager!.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: points),
        lineWidth: 5,
        lineColor: 0xFFD21E6A,
      ),
    );
  }

  Future<void> fitBounds(List<Position> coordinates) async {
    if (_map == null || coordinates.isEmpty) return;
    try {
      final cameraOptions = await _map!.cameraForCoordinatesPadding(
        coordinates.map((pos) => Point(coordinates: pos)).toList(),
        CameraOptions(),
        MbxEdgeInsets(top: 100.0, left: 50.0, bottom: 400.0, right: 50.0),
        null,
        null,
      );
      await _map!.flyTo(cameraOptions, MapAnimationOptions(duration: 2000));
    } catch (e) {
      await moveCamera(
        coordinates.first.lat.toDouble(),
        coordinates.first.lng.toDouble(),
        zoom: 12,
      );
    }
  }

  Future<void> addMarkers(
    double lat1,
    double lng1,
    double lat2,
    double lng2, {
    bool isUser = true,
  }) async {
    if (_markerManager == null) return;

    final ByteData driverBytes = await rootBundle.load(
      AssetConstants.driverLocation,
    );
    final Uint8List driver = driverBytes.buffer.asUint8List();

    await _markerManager!.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(lng1, lat1)),
        image: driver,
        iconSize: 3.6,
        iconOpacity: 0.9,
      ),
    );

    if (isUser) {
      final ByteData userBytes = await rootBundle.load(
        AssetConstants.userLocation,
      );
      final Uint8List user = userBytes.buffer.asUint8List();
      await _markerManager!.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng2, lat2)),
          image: user,
          iconSize: 3.4,
        ),
      );
    } else {
      final ByteData storeBytes = await rootBundle.load(
        AssetConstants.storeLocation,
      );
      final Uint8List store = storeBytes.buffer.asUint8List();
      await _markerManager!.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng2, lat2)),
          image: store,
          iconSize: 3.4,
        ),
      );
    }
  }

  Future<void> clearMarkers() async {
    await _markerManager?.deleteAll();
    await _polylineManager?.deleteAll();
  }

  Future<List<Position>> getRoute(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    return [Position(startLng, startLat), Position(endLng, endLat)];
  }
}
