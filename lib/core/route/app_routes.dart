import 'package:flutter/material.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/signup_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.onboardingView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.loginView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.applyView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.homeView:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
  return null;
}
