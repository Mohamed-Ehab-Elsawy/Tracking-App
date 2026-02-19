import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view/update_driver_view.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/profile_view.dart';
import '../../features/profile/presentation/profile_view_model/profile_events.dart';
import '../../features/profile/presentation/profile_view_model/profile_view_model.dart';
import '../di/di.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/signup_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
  static const String profileView = '/profile_view';
  static const String updateDriverView = '/update_driver_view';
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

    case AppRoutes.profileView:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) =>
              getIt<ProfileViewModel>()..doIntent(GetDriverDataEvent()),
          child: const ProfileView(),
        ),
      );
    case AppRoutes.updateDriverView:
      return MaterialPageRoute(
        settings: RouteSettings(arguments: settings.arguments),
        builder: (_) => BlocProvider(
          create: (_) => getIt<UpdateProfileViewModel>(),
          child: const UpdateDriverView(),
        ),
      );
  }
  return null;
}
