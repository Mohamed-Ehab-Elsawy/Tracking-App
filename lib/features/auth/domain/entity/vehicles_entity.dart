import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String type;

  const VehicleEntity({required this.type, required this.id});

  @override
  List<Object?> get props => [type];
}
