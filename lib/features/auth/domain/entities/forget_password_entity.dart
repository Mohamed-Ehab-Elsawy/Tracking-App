import 'package:equatable/equatable.dart';

class EmailVerificationResponseEntity extends Equatable {
  final String? message;

  final String? into;

  const EmailVerificationResponseEntity({this.message, this.into});

  @override
  List<Object?> get props => [message, into];
}

class VerificationCodeResponseEntity extends Equatable {
  const VerificationCodeResponseEntity(this.status);

  @override
  List<Object?> get props => [status];

  final String? status;
}

class ResetPasswordResponseEntity extends Equatable {
  final String? message;

  final String? token;

  const ResetPasswordResponseEntity({this.message, this.token});

  @override
  List<Object?> get props => [message, token];
}

class UserEntity extends Equatable {
  final String? email;

  final String? code;

  final String? password;

  const UserEntity({this.email, this.code, this.password});

  UserEntity copyWith({String? email, String? code, String? password}) {
    return UserEntity(
      email: email ?? this.email,
      code: code ?? this.code,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [email, code, password];
}
