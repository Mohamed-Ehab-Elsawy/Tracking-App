import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';

import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/domain/repository/profile_repo.dart';

@injectable
class UpdateDriverDataUseCase {
  ProfileRepo profileRepo;
  UpdateDriverDataUseCase(this.profileRepo);
  Future<Result<DriverEntity>> call({
    required UpdateProfileRequest editProfileRequest,
  }) async {
    return await profileRepo.updateProfileData(
      editProfileRequest: editProfileRequest,
    );
  }
}
