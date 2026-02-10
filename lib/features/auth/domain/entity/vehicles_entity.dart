import 'package:equatable/equatable.dart';

class VehicleEntity extends Equatable {
  final String type;

  const VehicleEntity({required this.type});

  @override
  List<Object?> get props => [type];
}
