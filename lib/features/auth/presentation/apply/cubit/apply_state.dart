import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/features/auth/domain/entity/apply_response_entity.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

class ApplyState extends Equatable {
  final BaseState<ApplyResponseEntity> applyState;
  final String? selectedGender;
  final BaseState<List<VehicleEntity>>? vehicleState;
  final File? nidImage;
  final File? vehicleLicense;
  const ApplyState({
    required this.applyState,
    this.selectedGender,
    this.vehicleState,
    this.nidImage,
    this.vehicleLicense,
  });
  factory ApplyState.initial() => ApplyState(applyState: BaseState.init());

  ApplyState copyWith({
    BaseState<ApplyResponseEntity>? applyState,
    String? selectedGender,
    BaseState<List<VehicleEntity>>? vehicleState,
    File? nidImage,
    File? vehicleLicense,
  }) => ApplyState(
    applyState: applyState ?? this.applyState,
    selectedGender: selectedGender ?? this.selectedGender,
    vehicleState: vehicleState ?? this.vehicleState,
    nidImage: nidImage ?? this.nidImage,
    vehicleLicense: vehicleLicense ?? this.vehicleLicense,
  );
  @override
  List<Object?> get props => [
    applyState,
    selectedGender,
    vehicleState,
    nidImage,
    vehicleLicense,
  ];
}
