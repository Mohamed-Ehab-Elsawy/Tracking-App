import 'dart:async';
import 'package:location/location.dart';

class LocationManager {
  static late Location _initLocation;
  LocationManager() {
    _initLocation = Location();
  }

  //PermissionLocation
  Future<bool> isPermissionGranted() async {
    var permissionStatus = await _initLocation.hasPermission();
    return permissionStatus == PermissionStatus.granted;
  }

  //requestPermission
  Future<bool> requestPermission() async {
    var permissionStatus = await _initLocation.requestPermission();
    return permissionStatus == PermissionStatus.granted;
  }

  //GPS
  Future<bool> isServiceEnable() async {
    var serviceEnable = await _initLocation.serviceEnabled();
    return serviceEnable;
  }

  //requestGps
  Future<bool> requestService() async {
    var service = await _initLocation.requestService();
    return service;
  }

  Future<LocationData?> getUserLocation() async {
    var permissionStatus = await requestPermission();
    var isServiceEnable = await requestService();

    if (!permissionStatus || !isServiceEnable) {
      return null;
    }
    return _initLocation.getLocation();
  }

  Stream<LocationData> updateLocation() {
    return _initLocation.onLocationChanged;
  }
}
