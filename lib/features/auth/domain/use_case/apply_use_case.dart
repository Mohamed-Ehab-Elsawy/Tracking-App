import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@injectable
class ApplyUseCase {
  final AuthRepository authRepository;
  ApplyUseCase(this.authRepository);

  Future<Result<ApplyResponseEntity>> invoke({
    required DriverEntity applyEntity,
    required File? nidImage,
    required File? vehicleLicense,
  }) => authRepository.apply(
    applyEntity,
    nidImage: nidImage,
    vehicleLicense: vehicleLicense,
  );
}
