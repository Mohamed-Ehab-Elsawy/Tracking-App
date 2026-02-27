import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/profile/domain/repository/profile_repo.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepo _profileRepo;
  const UploadPhotoUseCase(this._profileRepo);

  Future<Result<UploadPhotoResponse>> call({required File imageFile}) =>
      _profileRepo.uploadPhoto(imageFile: imageFile);
}
