import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

extension VehiclesMapperX on VehicleEntity {
  Vehicles toEntity() => Vehicles(type: type);
}
