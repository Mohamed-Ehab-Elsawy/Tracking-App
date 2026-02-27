part of 'change_password_view_model.dart';

class ChangePasswordState extends Equatable {
  final BaseState<ChangePasswordResponse> changePasswordState;

  const ChangePasswordState({required this.changePasswordState});

  factory ChangePasswordState.initial() =>
      ChangePasswordState(changePasswordState: BaseState.init());

  ChangePasswordState copyWith({
    BaseState<ChangePasswordResponse>? changePasswordState,
  }) {
    return ChangePasswordState(
      changePasswordState: changePasswordState ?? this.changePasswordState,
    );
  }

  @override
  List<Object?> get props => [changePasswordState];
}
