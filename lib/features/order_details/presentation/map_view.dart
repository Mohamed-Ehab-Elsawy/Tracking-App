import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/services/location_manager.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/widgets/loading_indicator.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_state.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_view_model.dart';

import 'widgets/bottom_sheet_container.dart';

class MapOrderView extends StatefulWidget {
  const MapOrderView({super.key, required this.order});

  final ActiveOrderDto? order;
  @override
  State createState() => MapOrderViewState();
}

class MapOrderViewState extends State<MapOrderView> {
  MapboxMap? mapboxMap;
  late LocationManager _locationManager;
  late MapOrderViewModel _viewModel;
  late StreamSubscription<MapOrderEvent> _eventSubscription;
  late StreamSubscription<LocationData>? _locationSubscription;

  Position? _lastPosition;
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    await _viewModel.initMap(mapboxMap);

    _locationSubscription = _locationManager.updateLocation().listen((
      location,
    ) {
      final lat = location.latitude;
      final lng = location.longitude;
      if (lat == null || lng == null) return;

      // Only re-fetch directions if moved more than ~20 meters
      final newPos = Position(lng, lat);
      if (_hasMovedSignificantly(newPos)) {
        _lastPosition = newPos;
        _viewModel.doIntent(
          GetDirectionsIntent(
            startLat: lat,
            startLng: lng,
            // endLat: widget.order?.latitude ?? 30.0626,   // ← use order data
            // endLng: widget.order?.longitude ?? 31.2497,
            endLat: 30.0626,
            endLng: 31.2497,
          ),
        );
      }
    });
  }

  bool _hasMovedSignificantly(Position newPos) {
    if (_lastPosition == null) return true;
    final latDiff = (newPos.lat - _lastPosition!.lat).abs();
    final lngDiff = (newPos.lng - _lastPosition!.lng).abs();
    return latDiff > 0.0002 || lngDiff > 0.0002; // ~20m threshold
  }

  @override
  void initState() {
    super.initState();
    _locationManager = LocationManager();
    _locationManager.requestPermission();
    _viewModel = context.read<MapOrderViewModel>();
    _eventSubscription = _viewModel.eventStream.listen((event) {
      if (!mounted) return;
      if (event is MapOrderErrorEvent) {
        AppSnackBar.show(context, event.errorMessage, isError: true);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  final CameraOptions _initCamera = CameraOptions(
    center: Point(coordinates: Position(-98.0, 39.5)),
    zoom: 2,
    bearing: 0,
    pitch: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMapUI(),
          _buildLoadingOverlay(),
          _buildBackButton(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() =>
      BlocBuilder<MapOrderViewModel, MapOrderState>(
        builder: (context, state) {
          if (state.directions.isLoading) {
            return Container(
              color: Colors.black.withAlpha(76),
              child: const Center(child: LoadingIndicator()),
            );
          }
          return const SizedBox.shrink();
        },
      );

  _buildMapUI() => MapWidget(
    key: ValueKey("mapWidget"),
    onMapCreated: _onMapCreated,
    cameraOptions: _initCamera,
    onStyleLoadedListener: (style) {},
  );
  _buildBottomSheet() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: BottomSheetContainer(order: widget.order!, firstStore: true),
  );
  _buildBackButton() => Positioned(
    top: 68,
    left: 16,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
    ),
  );
}
