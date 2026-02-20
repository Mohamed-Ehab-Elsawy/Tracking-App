import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';

sealed class UpdateProfileEvents {}

sealed class UpdateProfileUiEvents {}

class UpdateDataEvent extends UpdateProfileEvents {
  final UpdateProfileRequest updateProfileRequest;
  UpdateDataEvent(this.updateProfileRequest);
}

class NavigateToResetPassword extends UpdateProfileUiEvents {}

class ShowToast extends UpdateProfileUiEvents {
  final String message;
  final bool isError;
  ShowToast({required this.message, required this.isError});
}

final class SelectLocalPhoto extends UpdateProfileEvents {
  final File file;
  SelectLocalPhoto(this.file);
}

class UploadPhoto extends UpdateProfileEvents {
  final File imageFile;
  UploadPhoto(this.imageFile);
}

final class PickImageFromCamera extends UpdateProfileEvents {}

final class PickImageFromGallery extends UpdateProfileEvents {}

final class PopWithImageSource extends UpdateProfileUiEvents {
  final ImageSource source;
  PopWithImageSource(this.source);
}
