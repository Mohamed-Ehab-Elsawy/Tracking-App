import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/bloc/my_bloc_observer.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/constants/localization_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/services/fcm_service.dart';
import 'package:tracking_app/tracking_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();
  await FCMService.getAccessToken().then((fcmAccessToken) {
    AppLocalStorage.setSecuredString(
      key: AppConstants.fcmAccessToken,
      value: fcmAccessToken,
    );
  });
  await EasyLocalization.ensureInitialized();
  await configureDependencies();

  Bloc.observer = MyBlocObserver();

  runApp(_buildApp());
}

Widget _buildApp() => EasyLocalization(
  saveLocale: true,
  supportedLocales: const [
    Locale(LocalizationConstants.enLocaleKey),
    Locale(LocalizationConstants.arLocaleKey),
  ],
  path: AssetConstants.translationsPath,
  fallbackLocale: const Locale(LocalizationConstants.enLocaleKey),
  child: const TrackingApp(),
);
