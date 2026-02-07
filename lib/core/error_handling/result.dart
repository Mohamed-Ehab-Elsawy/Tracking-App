import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Failure<T> extends Result<T> {
  final String errorMessage;
  Failure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
