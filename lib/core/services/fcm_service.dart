import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tracking_app/core/constants/asset_constants.dart';

class FCMService {
  static Future<String> getAccessToken() async {
    final jsonString = await rootBundle.loadString(
      AssetConstants.serviceAccountPath,
    );
    final jsonData = jsonDecode(jsonString);
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonData);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = http.Client();
    try {
      final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        scopes,
        client,
      );
      return accessCredentials.accessToken.data;
    } finally {
      client.close();
    }
  }
}
