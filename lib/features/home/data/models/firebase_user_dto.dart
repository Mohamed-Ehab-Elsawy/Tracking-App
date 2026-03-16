import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'firebase_user_dto.g.dart';

@JsonSerializable()
class FirebaseUserDto {
  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'deviceToken')
  final String token;

  FirebaseUserDto({this.userId = '', this.token = ''});

  factory FirebaseUserDto.fromJson(Map<String, dynamic> json) =>
      _$FirebaseUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseUserDtoToJson(this);
  UserEntity toEntity() {
    return UserEntity(userId: userId, token: token);
  }
}
