import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';

sealed class ApplyEvent {}

class NavigateSuccessApplyIntent extends ApplyEvent {}

class NavigateBackIntent extends ApplyEvent {}

class ShowSnackBarEvent extends ApplyEvent {
  final String message;
  final bool isError;
  ShowSnackBarEvent({required this.message, required this.isError});
}

sealed class ApplyIntent extends Equatable {
  const ApplyIntent();
  @override
  List<Object?> get props => [];
}

class GetVehiclesIntent extends ApplyIntent {}

class UploadImageIntent extends ApplyIntent {
  final File image;
  final bool isNid;
  const UploadImageIntent({required this.image, required this.isNid});

  @override
  List<Object?> get props => [image, isNid];
}

class ChoseImageFromGalleryIntent extends ApplyIntent {
  final File image;
  final bool isNid;
  const ChoseImageFromGalleryIntent({required this.image, required this.isNid});

  @override
  List<Object?> get props => [image, isNid];
}

class SubmitApplyIntent extends ApplyIntent {
  final DriverEntity driverEntity;

  const SubmitApplyIntent({required this.driverEntity});

  @override
  List<Object?> get props => [driverEntity];
}

class SelectGender extends ApplyIntent {
  final String gender;
  const SelectGender(this.gender);

  @override
  List<Object?> get props => [gender];
}
