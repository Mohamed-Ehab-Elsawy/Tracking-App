sealed class Intent {}

final class ChangePasswordIntent extends Intent {
  final String password;
  final String newPassword;
  ChangePasswordIntent({required this.password, required this.newPassword});
}

sealed class ChangePasswordUiIntent {}

final class ChangePasswordShowToast extends ChangePasswordUiIntent {
  final String message;
  bool isError;
  ChangePasswordShowToast({required this.message, this.isError = false});
}

final class PopScreenIntent extends ChangePasswordUiIntent {}
