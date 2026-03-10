class UserEntity {
  String userId;
  String token;

  UserEntity({this.userId = "", this.token = ""});

  factory UserEntity.fromMap(Map<String, dynamic> map) =>
      UserEntity(userId: map['userId'] ?? '', token: map['deviceToken'] ?? '');
}
