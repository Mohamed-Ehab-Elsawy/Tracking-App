import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/light_theme.dart';

class TrackingApp extends StatefulWidget {
  const TrackingApp({super.key});

  @override
  State<TrackingApp> createState() => _TrackingAppState();
}

class _TrackingAppState extends State<TrackingApp> {
  bool logged = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    final status = await AppLocalStorage.getBool(AppConstants.rememberMeKey);
    setState(() {
      logged = status;
    });
  }

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
        initialRoute: logged ? AppRoutes.homeView : AppRoutes.onboardingView,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
