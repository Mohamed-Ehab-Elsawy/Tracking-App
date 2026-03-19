import 'package:json_annotation/json_annotation.dart';

part 'directions_model.g.dart';

@JsonSerializable()
class DirectionsResponse {
  final List<MapboxRoute> routes;
  final String code;

  DirectionsResponse({required this.routes, required this.code});

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$DirectionsResponseFromJson(json);
}

@JsonSerializable()
class MapboxRoute {
  final Geometry geometry;
  final double distance;
  final double duration;

  MapboxRoute({
    required this.geometry,
    required this.distance,
    required this.duration,
  });

  factory MapboxRoute.fromJson(Map<String, dynamic> json) =>
      _$MapboxRouteFromJson(json);
}

@JsonSerializable()
class Geometry {
  final List<List<double>> coordinates;
  final String type;

  Geometry({required this.coordinates, required this.type});

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);
}
