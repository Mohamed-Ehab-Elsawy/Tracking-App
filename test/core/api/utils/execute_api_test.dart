import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:tracking_app/core/api/utils/execute_api.dart';
import 'package:tracking_app/core/error_handling/result.dart';

void main() {
  group('executeApi', () {
    test('should return Success when the API call is successful', () async {
      // Arrange
      Future<String> mockApiCall() async => 'Data fetched successfully';

      // Act
      final result = await executeApi(() => mockApiCall());

      // Assert
      expect(result, isA<Success<String>>());
      expect((result as Success).data, 'Data fetched successfully');
    });

    test(
      'should return Failure with translated message when Exception is thrown',
      () async {
        // Arrange
        Future<String> mockApiCall() async {
          throw DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionTimeout,
          );
        }

        // Act
        final result = await executeApi(() => mockApiCall());

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'errors.connectionTimeout');
      },
    );

    test('should return Failure for general Exceptions (unexpected)', () async {
      // Arrange
      Future<String> mockApiCall() async => throw Exception('Critical fail');

      // Act
      final result = await executeApi(() => mockApiCall());

      // Assert
      expect(result, isA<Failure>());
      expect((result as Failure).errorMessage, 'errors.unexpected');
    });

    test(
      'should handle specific Dio badResponse cases inside executeApi',
      () async {
        // Arrange
        Future<String> mockApiCall() async {
          throw DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 500,
            ),
          );
        }

        // Act
        final result = await executeApi(() => mockApiCall());

        // Assert
        expect(result, isA<Failure>());
        expect((result as Failure).errorMessage, 'errors.error500');
      },
    );
  });
}
