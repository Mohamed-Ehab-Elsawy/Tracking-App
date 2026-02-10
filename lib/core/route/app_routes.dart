import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

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
      return MaterialPageRoute(
        builder: (context) => BlocProvider<ForgetPasswordViewModel>(
          create: (context) => getIt.get<ForgetPasswordViewModel>(),
          child: const ForgetPasswordView(),
        ),
      );

    case AppRoutes.homeView:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
  return null;
}
