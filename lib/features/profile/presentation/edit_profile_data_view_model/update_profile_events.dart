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
