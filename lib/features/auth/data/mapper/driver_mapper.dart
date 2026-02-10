import 'package:tracking_app/features/auth/data/mapper/vehicles_mapper.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';

extension DriverMapperX on DriverEntity {
  ApplyRequest toRequest() => ApplyRequest(
    country: country,
    firstName: firstName,
    lastName: lastName,
    vehicleType: vehicleType?.toEntity(),
    vehicleNumber: vehicleNumber,
    nID: nid,
    email: email,
    password: password,
    rePassword: rePassword,
    gender: gender,
    phone: phone,
  );
}
