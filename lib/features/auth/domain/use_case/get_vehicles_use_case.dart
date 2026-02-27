import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class GetVehiclesUseCase {
  final AuthRepository authRepository;
  GetVehiclesUseCase(this.authRepository);

  Future<Result<List<VehicleEntity>>> invoke() =>
      authRepository.getAllVehicles();
}
