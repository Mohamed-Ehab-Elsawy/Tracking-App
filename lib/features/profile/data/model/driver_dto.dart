import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
part 'driver_dto.g.dart';

@JsonSerializable()
class DriverDto {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "firstName")
  final String? firstName;
  @JsonKey(name: "lastName")
  final String? lastName;
  @JsonKey(name: "vehicleType")
  final String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  final String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  final String? vehicleLicense;
  @JsonKey(name: "NID")
  final String? nID;
  @JsonKey(name: "NIDImg")
  final String? nIDImg;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "photo")
  final String? photo;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "createdAt")
  final String? createdAt;

  DriverDto({
    this.id,
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nID,
    this.nIDImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.createdAt,
  });

  factory DriverDto.fromJson(Map<String, dynamic> json) {
    return _$DriverDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DriverDtoToJson(this);
  }

  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      country: country,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
      nID: nID,
      nIDImg: nIDImg,
      email: email,
      gender: gender,
      photo: photo,
      role: role,
      createdAt: createdAt,
    );
  }
}
