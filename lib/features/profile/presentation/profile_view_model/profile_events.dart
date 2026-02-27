sealed class ProfileEvents {}

sealed class ProfileUiEvents {}

class GetDriverDataEvent extends ProfileEvents {}

class OnLanguageClickIntent extends ProfileUiEvents {}

class OnLogoutClickIntent extends ProfileUiEvents {}

class OnProfileClickIntent extends ProfileUiEvents {}

class OnVehicleInfoClickIntent extends ProfileUiEvents {}

class NavigateToNotification extends ProfileUiEvents {}
