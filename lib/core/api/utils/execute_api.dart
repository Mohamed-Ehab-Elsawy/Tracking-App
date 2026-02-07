import 'package:tracking_app/core/error_handling/handle_exception.dart';
import 'package:tracking_app/core/error_handling/result.dart';

Future<Result<T>> executeApi<T>(Future<T> Function() callApi) async {
  try {
    var result = await callApi.call();
    return Success(result);
  } on Exception catch (e) {
    return Failure(ExceptionHandler.getMessageError(e));
  }
}
