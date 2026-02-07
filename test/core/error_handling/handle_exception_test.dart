import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/error_handling/handle_exception.dart';

void main() {
  group('ExceptionHandler.getMessageError - DioException Tests', () {
    test('should return connectionTimeout error message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionTimeout,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.connectionTimeout');
    });

    test('should return sendTimeout error message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.sendTimeout,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.sendTimeout');
    });

    test('should return receiveTimeout error message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.receiveTimeout,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.receiveTimeout');
    });

    test('should return badCertificate error message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badCertificate,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.badCertificate');
    });

    test('should return cancel error message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.cancel,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.cancel');
    });

    test('should return connectionError message', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.connectionError');
    });

    test('should return unknown message for DioExceptionType.unknown', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.unknown');
    });
  });

  group('ExceptionHandler - HTTP Status Code Handling (badResponse)', () {
    DioException createDioResponseException(int statusCode, {dynamic data}) {
      return DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: statusCode,
          data: data,
        ),
      );
    }

    test('should handle 400 error', () {
      final ex = createDioResponseException(400);
      expect(ExceptionHandler.getMessageError(ex), 'errors.error400');
    });

    test('should handle 401 error and append data message', () {
      final ex = createDioResponseException(
        401,
        data: {'error': 'Unauthorized Access'},
      );
      expect(
        ExceptionHandler.getMessageError(ex),
        'errors.error401Unauthorized Access',
      );
    });

    test('should handle 403 error', () {
      final ex = createDioResponseException(403);
      expect(ExceptionHandler.getMessageError(ex), 'errors.error403');
    });

    test('should handle 404 error and return data error string', () {
      final ex = createDioResponseException(
        404,
        data: {'error': 'Not Found Content'},
      );
      expect(ExceptionHandler.getMessageError(ex), 'Not Found Content');
    });

    test('should handle 408, 429, 500, 502, 503, 504 errors', () {
      final codes = [408, 429, 500, 502, 503, 504];
      for (var code in codes) {
        final ex = createDioResponseException(code);
        expect(ExceptionHandler.getMessageError(ex), 'errors.error$code');
      }
    });

    test('should handle default server error when status code is unknown', () {
      final ex = createDioResponseException(418); // I'm a teapot
      expect(
        ExceptionHandler.getMessageError(ex),
        'Server error (418). Please try again.',
      );
    });

    test(
      'should return custom error from Map data if status code is default',
      () {
        final ex = createDioResponseException(
          499,
          data: {'error': 'Custom Logic Error'},
        );
        expect(ExceptionHandler.getMessageError(ex), 'Custom Logic Error');
      },
    );

    test('should return unknown if response is null', () {
      final ex = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: null,
      );
      expect(ExceptionHandler.getMessageError(ex), 'errors.unknown');
    });
  });

  group('ExceptionHandler - General Exceptions', () {
    test('should handle SocketException', () {
      const ex = SocketException('No Internet');
      expect(ExceptionHandler.getMessageError(ex), 'errors.noInternet');
    });

    test('should handle TimeoutException', () {
      final ex = TimeoutException('Timeout');
      expect(ExceptionHandler.getMessageError(ex), 'errors.timeout');
    });

    test('should handle FormatException', () {
      const ex = FormatException('Bad Format');
      expect(ExceptionHandler.getMessageError(ex), 'errors.invalidFormat');
    });

    test('should handle PlatformException with message', () {
      final ex = PlatformException(
        code: '500',
        message: 'Platform Specific Error',
      );
      expect(ExceptionHandler.getMessageError(ex), 'Platform Specific Error');
    });

    test('should handle PlatformException without message', () {
      final ex = PlatformException(code: '500', message: null);
      expect(ExceptionHandler.getMessageError(ex), 'errors.platform');
    });

    test('should handle any other unexpected Exception', () {
      final ex = Exception('Unknown Exception');
      expect(ExceptionHandler.getMessageError(ex), 'errors.unexpected');
    });
  });
}
