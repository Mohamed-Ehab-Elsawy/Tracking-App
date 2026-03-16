class NotificationDto {
  final String? title;
  final String? body;
  final String? status;

  NotificationDto({required this.title, required this.body, this.status});
  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      NotificationDto(
        title: json['title'],
        body: json['body'],
        status: json['status'],
      );
  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'status': status,
  };
}
