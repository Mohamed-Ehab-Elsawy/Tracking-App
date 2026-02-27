import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/models/change_password/change_password_response.dart';
import 'dart:io';

import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/model/request/apply_request.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/data/model/response/get_all_vehicles_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<Result<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}


Future<Result<ApplyResponse>> apply(ApplyRequest applyRequest, {
  required File? nidImage,
  required File? vehicleLicense,
});

Future<Result<GetAllVehiclesResponse>> getAllVehicles();

Future<Result<String>> login(String email, String password);

Future<Result<EmailVerificationResponseDto>> emailVerification(UserDto user);

Future<Result<VerificationCodeResponseDto>> codeVerification(UserDto user);

Future<Result<ResetPasswordResponseDto>> resetPassword(UserDto user);}
