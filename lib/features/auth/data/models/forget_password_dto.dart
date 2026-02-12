import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'forget_password_dto.g.dart';

@JsonSerializable()
class EmailVerificationResponseDto extends Equatable {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "info")
  final String? into;

  const EmailVerificationResponseDto({this.message, this.into});

  factory EmailVerificationResponseDto.fromJson(Map<String, dynamic> json) {
    return _$EmailVerificationResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$EmailVerificationResponseDtoToJson(this);
  }

  @override
  List<Object?> get props => [message, into];
}

@JsonSerializable()
class VerificationCodeResponseDto extends Equatable {
  const VerificationCodeResponseDto({this.status});

  factory VerificationCodeResponseDto.fromJson(Map<String, dynamic> json) {
    return _$VerificationCodeResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VerificationCodeResponseDtoToJson(this);
  }

  @override
  List<Object?> get props => [status];

  @JsonKey(name: "status")
  final String? status;
}

@JsonSerializable()
class ResetPasswordResponseDto extends Equatable {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;

  const ResetPasswordResponseDto({this.message, this.token});

  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) {
    return _$ResetPasswordResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ResetPasswordResponseDtoToJson(this);
  }

  @override
  List<Object?> get props => [message, token];
}

@JsonSerializable(includeIfNull: false)
class UserDto extends Equatable {
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "resetCode")
  final String? code;
  @JsonKey(name: "newPassword")
  final String? password;
  const UserDto({this.email, this.code, this.password});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return _$UserDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserDtoToJson(this);
  }

  @override
  List<Object?> get props => [email, code, password];
}
