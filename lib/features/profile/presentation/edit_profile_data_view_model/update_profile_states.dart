import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/profile/data/model/response/upload_photo_response.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';

class UpdateProfileStates extends Equatable {
  final BaseState<DriverEntity>? updateDriverData;
  final BaseState<UploadPhotoResponse>? uploadPhotoStates;
  final File? localImage;
  const UpdateProfileStates({
    this.updateDriverData,
    this.uploadPhotoStates,
    this.localImage,
  });

  @override
  List<Object?> get props => [updateDriverData, uploadPhotoStates, localImage];

  UpdateProfileStates copyWith({
    BaseState<DriverEntity>? updateDriverData,
    BaseState<UploadPhotoResponse>? uploadPhotoStates,
    File? localImage,
  }) {
    return UpdateProfileStates(
      updateDriverData: updateDriverData ?? this.updateDriverData,
      uploadPhotoStates: uploadPhotoStates ?? this.uploadPhotoStates,
      localImage: localImage ?? this.localImage,
    );
  }
}
