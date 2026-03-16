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
  late String orderId;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    final logedStatus = await AppLocalStorage.getBool(
      AppConstants.rememberMeKey,
    );
    orderId = await AppLocalStorage.getString(key: AppConstants.orderId);

    setState(() {
      logged = logedStatus;
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

  String? init() {
    if (!logged) {
      return AppRoutes.onboardingView;
    } else if (logged && orderId.isNotEmpty) {
      return AppRoutes.homeView;
    }
    return AppRoutes.homeView;
  }
}
