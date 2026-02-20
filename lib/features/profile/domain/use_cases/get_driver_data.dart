import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';

import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/repository/profile_repo.dart';

@injectable
class GetDriverDataUseCase {
  ProfileRepo profileRepo;
  GetDriverDataUseCase(this.profileRepo);
  Future<Result<DriverEntity>> call() async {
    return await profileRepo.getDriverData();
  }
}
