class SendNotificationRequest {
  final String targetToken;
  final String title;
  final String body;
  final Map<String, dynamic>? data;

  SendNotificationRequest(this.targetToken, this.title, this.body, this.data);

  Map<String, dynamic> toJson() => {
    'message': {
      'token': targetToken,
      'notification': {'title': title, 'body': body},
      'data': data ?? {},
      'android': {
        'priority': 'high',
        'notification': {'channel_id': 'high_importance_channel'},
      },
      'apns': {
        'headers': {'apns-priority': '10'},
      },
    },
  };
}
