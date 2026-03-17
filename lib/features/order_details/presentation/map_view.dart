import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracking_app/core/services/location_manager.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/widgets/loading_indicator.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_state.dart';
import 'widgets/bottom_sheet_container.dart';

class MapOrderView extends StatefulWidget {
  const MapOrderView({super.key, required this.order, required this.isUser});
  final ActiveOrderDto order;
  final bool isUser;
  @override
  State createState() => MapOrderViewState();
}

class MapOrderViewState extends State<MapOrderView> {
  MapboxMap? mapboxMap;
  late MapOrderViewModel _viewModel;
  late LocationManager _locationManager;
  late StreamSubscription<MapOrderEvent> _eventSubscription;


  LocationData? _currentLocation;
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    await _viewModel.initMap(mapboxMap);

    _currentLocation = await _locationManager.getUserLocation();
    print("''''current''''''''''''''''''''''''${_currentLocation?.latitude}''''''''''''''''''''''''''''");
    print("''''current''''''''''''''''''''''''${_currentLocation?.longitude}''''''''''''''''''''''''''''");
    double storeEndLat = widget.order.storeLat ;
    double storeEndLng = widget.order.storeLng;
    print("''''''store''''''''''''''''''''''$storeEndLng''''''''''''''''''''''''''''");
    print("''''''store''''''''''''''''''''''$storeEndLat''''''''''''''''''''''''''''");
    double userEndLat = double.parse(widget.order.lat!);
    double userEndLng = double.parse(widget.order.long!);
    print("''''''user''''''''''''''''''''''$userEndLat''''''''''''''''''''''''''''");
    print("''''''user''''''''''''''''''''''$userEndLng''''''''''''''''''''''''''''");

    _viewModel.doIntent(
      GetDirectionsIntent(
        startLat: _currentLocation?.latitude ?? 30.000,
        startLng: _currentLocation?.longitude ?? 30.0626,
        endLat: widget.isUser ? userEndLat : storeEndLat,
        endLng: widget.isUser ? userEndLng : storeEndLng,
      ),
    );


  }

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<MapOrderViewModel>();
    _locationManager = LocationManager()..requestPermission();

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
    child: BottomSheetContainer(order: widget.order, firstStore: widget.isUser),
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
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
    ),
  );
}
