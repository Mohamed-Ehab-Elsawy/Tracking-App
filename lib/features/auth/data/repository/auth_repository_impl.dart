import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/error_handling/result.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/mapper/apply_rsponse_mappr.dart';
import 'package:tracking_app/features/auth/data/mapper/driver_mapper.dart';
import 'package:tracking_app/features/auth/data/model/response/apply_response.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/domain/repository/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Result<ApplyResponseEntity>> apply(
    DriverEntity applyEntity, {
    MultipartFile? nidImage,
    MultipartFile? vehicleLicense,
  }) async {
    final requestDto = applyEntity.toRequest();

    var result = await authRemoteDataSource.apply(
      requestDto,
      nidImage: null,
      vehicleLicense: null,
    );
    switch (result) {
      case Success<ApplyResponse>():
        return Success(result.data.toEntity());
      case Failure<ApplyResponse>():
        return Failure(result.errorMessage);
    }
  }
}
