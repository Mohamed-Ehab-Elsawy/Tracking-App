import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/auth/data/model/response/vehicles.dart';

part 'apply_request.g.dart';

@JsonSerializable()
class ApplyRequest extends Equatable {
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "vehicleType")
  final Vehicles? vehicleType;
  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;
  @JsonKey(name: "NID")
  final String? nID;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "rePassword")
  final String? rePassword;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;

  ApplyRequest({
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.nID,
    this.email,
    this.password,
    this.rePassword,
    this.gender,
    this.phone,
  });

  factory ApplyRequest.fromJson(Map<String, dynamic> json) {
    return _$ApplyRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ApplyRequestToJson(this);
  }

  @override
  List<Object?> get props => [
    country,
    firstName,
    lastName,
    vehicleType,
    vehicleNumber,
    nID,
    email,
    password,
    rePassword,
    gender,
    phone,
  ];
}
