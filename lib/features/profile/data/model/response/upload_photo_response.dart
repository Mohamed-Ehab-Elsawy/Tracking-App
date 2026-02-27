class UploadPhotoResponse {
  final String? message;

  const UploadPhotoResponse({this.message});

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) =>
      UploadPhotoResponse(message: json['message']);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}
