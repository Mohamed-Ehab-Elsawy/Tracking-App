import 'package:flutter/material.dart';
import 'package:tracking_app/features/auth/presentation/apply/apply_view.dart';
import 'package:tracking_app/features/auth/presentation/login/login_view.dart';
import 'package:tracking_app/features/onboarding/view/onboarding_view.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/apply_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.onboardingView:
      return MaterialPageRoute(builder: (context) => const OnboardingView());

    case AppRoutes.loginView:
      return MaterialPageRoute(builder: (context) => const LoginView());

    case AppRoutes.applyView:
      return MaterialPageRoute(builder: (context) => const ApplyView());

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.homeView:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
  return null;
}
