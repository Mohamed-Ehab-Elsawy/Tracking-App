import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/bloc/my_bloc_observer.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/constants/localization_constants.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/tracking_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await configureDependencies();
  runApp(
    EasyLocalization(
      saveLocale: true,
      supportedLocales: const [
        Locale(LocalizationConstants.enLocaleKey),
        Locale(LocalizationConstants.arLocaleKey),
      ],
      path: AssetConstants.translationsPath,
      fallbackLocale: const Locale(LocalizationConstants.enLocaleKey),
      child: const TrackingApp(),
    ),
  );
}
