import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';

class TrackingApp extends StatelessWidget {
  const TrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      appTheme: LightTheme(),
      child: MaterialApp(
        title: AppConstants.appName.tr(),
        debugShowCheckedModeBanner: false,
        theme: LightTheme().themeData,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: AppRoutes.initialRoute,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
