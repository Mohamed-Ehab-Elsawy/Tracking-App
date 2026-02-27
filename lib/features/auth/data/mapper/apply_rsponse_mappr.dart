import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';

extension VehiclesMapperX on ApplyResponse {
  ApplyResponseEntity toEntity() =>
      ApplyResponseEntity(message: message, token: token);
}
