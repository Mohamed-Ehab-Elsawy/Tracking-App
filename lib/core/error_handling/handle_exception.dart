import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ExceptionHandler {
  static String getMessageError(Exception exception) {
    if (exception is DioException) {
      switch (exception.type) {
        case DioExceptionType.connectionTimeout:
          return 'errors.connectionTimeout'.tr();
        case DioExceptionType.sendTimeout:
          return 'errors.sendTimeout'.tr();
        case DioExceptionType.receiveTimeout:
          return 'errors.receiveTimeout'.tr();
        case DioExceptionType.badCertificate:
          return 'errors.badCertificate'.tr();
        case DioExceptionType.badResponse:
          return _handleMessageResponse(exception);
        case DioExceptionType.cancel:
          return 'errors.cancel'.tr();
        case DioExceptionType.connectionError:
          return 'errors.connectionError'.tr();
        case DioExceptionType.unknown:
          return 'errors.unknown'.tr();
      }
    } else if (exception is SocketException) {
      return 'errors.noInternet'.tr();
    } else if (exception is TimeoutException) {
      return 'errors.timeout'.tr();
    } else if (exception is FormatException) {
      return 'errors.invalidFormat'.tr();
    } else if (exception is PlatformException) {
      return exception.message ?? 'errors.platform'.tr();
    } else if (exception is FirebaseException) {
      return exception.message ?? 'errors.firebase'.tr();
    } else {
      return 'errors.unexpected'.tr();
    }
  }

  static String _handleMessageResponse(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final data = e.response!.data;

      switch (e.response!.statusCode) {
        case 400:
          return 'errors.error400'.tr();
        case 401:
          return 'errors.error401'.tr() + data['error'].toString();
        case 403:
          return 'errors.error403'.tr();
        case 404:
          return data['error'].toString();
        case 408:
          return 'errors.error408'.tr();
        case 429:
          return 'errors.error429'.tr();
        case 500:
          return 'errors.error500'.tr();
        case 502:
          return 'errors.error502'.tr();
        case 503:
          return 'errors.error503'.tr();
        case 504:
          return 'errors.error504'.tr();
        default:
          if (data is Map && data['error'] != null) {
            return data['error'].toString();
          }
          return 'Server error (${statusCode ?? 'unknown'}). Please try again.';
      }
    }
    return 'errors.unknown'.tr();
  }
}
