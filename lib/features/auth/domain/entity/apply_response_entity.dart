import 'package:equatable/equatable.dart';

class ApplyResponseEntity extends Equatable {
  final String? message;
  final String? token;

  const ApplyResponseEntity({this.message, this.token});

  @override
  List<Object?> get props => [message, token];
}
