import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_success_view.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/signup_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
  static const String applySuccessView = '/apply_success_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.onboardingView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.loginView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.applyView:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              getIt<ApplyViewModel>()..doIntent(GetVehiclesIntent()),
          child: const ApplyView(),
        ),
      );

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.homeView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.applySuccessView:
      return MaterialPageRoute(builder: (context) => const ApplySuccessView());
  }
  return null;
}
