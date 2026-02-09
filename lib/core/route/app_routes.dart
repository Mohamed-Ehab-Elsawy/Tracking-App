import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/login/login_view.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';

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
      var cubit = getIt.get<LoginCubit>();
      return MaterialPageRoute(
        builder: (context) =>
            BlocProvider(create: (context) => cubit, child: const LoginView()),
      );

    case AppRoutes.applyView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(builder: (context) => const Scaffold());

    case AppRoutes.homeView:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
  return null;
}
