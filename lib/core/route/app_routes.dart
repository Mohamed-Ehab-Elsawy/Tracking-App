import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/change_password/views/change_password_view.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/signup_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
  static const String changePassword = '/change_password';
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

    case AppRoutes.changePassword:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<ChangePasswordViewModel>(),
          child: const ChangePasswordView(),
        ),
      );
  }
  return null;
}
