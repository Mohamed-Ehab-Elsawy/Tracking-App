import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

extension VehiclesMapperX on Vehicles {
  VehicleEntity toEntity() => VehicleEntity(type: type ?? "", id: id ?? "");
}

extension VehicleEntityExtension on VehicleEntity {
  Vehicles toModel() => Vehicles(type: type, id: id);
}
