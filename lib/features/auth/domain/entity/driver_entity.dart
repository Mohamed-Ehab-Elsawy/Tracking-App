import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/auth/domain/entity/vehicles_entity.dart';

class DriverEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? email;
  final String? phone;
  final String? nid;
  final String? gender;
  final String? vehicleNumber;
  final VehicleEntity? vehicleType;
  final String? password;
  final String? rePassword;
  final File? vehicleLicense;
  final File? nidImage;

  const DriverEntity({
    this.firstName,
    this.lastName,
    this.country,
    this.email,
    this.phone,
    this.nid,
    this.gender,
    this.vehicleNumber,
    this.vehicleType,
    this.password,
    this.rePassword,
    this.vehicleLicense,
    this.nidImage,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    country,
    email,
    phone,
    nid,
    gender,
    vehicleNumber,
    vehicleType,
    password,
    rePassword,
    vehicleLicense,
    nidImage,
  ];
}
