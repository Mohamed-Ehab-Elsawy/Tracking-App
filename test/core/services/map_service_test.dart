import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/services/map_service.dart';

import 'map_service_test.mocks.dart';

@GenerateMocks([
  MapboxMap,
  CameraOptions,
  PointAnnotationManager,
  PolylineAnnotationManager,
])
void main() {
  late MapService service;
  late MockMapboxMap mockMap;
  late MockPointAnnotationManager mockMarkerManager;
  late MockPolylineAnnotationManager mockPolylineManager;

  setUp(() {
    service = MapService();

    mockMap = MockMapboxMap();
    mockMarkerManager = MockPointAnnotationManager();
    mockPolylineManager = MockPolylineAnnotationManager();
  });

  group("initMap()", () {
    group("moveCamera()", () {
      test("does nothing when map is null", () async {
        await service.moveCamera(10, 20);
        verifyNever(mockMap.flyTo(any, any));
      });
    });

    group("drawRoute()", () {
      test("does nothing when polylineManager is null", () async {
        await service.drawRoute([]);
        verifyNever(mockPolylineManager.create(any));
      });
    });

    group("addMarkers()", () {
      test("does nothing if manager is null", () async {
        await service.addMarkers(10, 20, 30, 40);
        verifyNever(mockMarkerManager.create(any));
      });
    });

    group("fitBounds()", () {
      test("does nothing if map is null", () async {
        await service.fitBounds([Position(10, 20)]);
        verifyNever(
          mockMap.cameraForCoordinatesPadding(any, any, any, any, any),
        );
      });
    });

    group("getRoute()", () {
      test("returns route points", () async {
        final result = await service.getRoute(1, 2, 3, 4);

        expect(result.length, 2);
        expect(result.first.lng, 2);
        expect(result.first.lat, 1);
        expect(result.last.lng, 4);
        expect(result.last.lat, 3);
      });
    });
  });
}
