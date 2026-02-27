import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_success_view.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/change_password/views/change_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view/order_details_view.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/auth/presentation/login/login_view.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/onboarding/view/onboarding_view.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view/update_driver_view.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';
import 'package:tracking_app/features/sections/presentation/sections_view.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/apply_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
  static const String orderHistory = '/orderHistory';
  static const String orderDetails = '/orderDetails';
  static const String changePassword = '/change_password';
  static const String applySuccessView = '/apply_success_view';
  static const String profileView = '/profile_view';
  static const String updateDriverView = '/update_driver_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.homeView:
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<SectionsCubit>()),
            BlocProvider(create: (context) => getIt<OrderHistoryCubit>()),
            BlocProvider(create: (context) => getIt<ProfileViewModel>()),
          ],
          child: SectionsView(),
        ),
      );
    case AppRoutes.onboardingView:
      return MaterialPageRoute(builder: (context) => const OnboardingView());

    case AppRoutes.loginView:
      var cubit = getIt.get<LoginCubit>();
      return MaterialPageRoute(
        builder: (context) =>
            BlocProvider(create: (context) => cubit, child: const LoginView()),
      );

    case AppRoutes.applyView:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              getIt<ApplyViewModel>()..doIntent(GetVehiclesIntent()),
          child: const ApplyView(),
        ),
      );

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<ForgetPasswordViewModel>(
          create: (context) => getIt.get<ForgetPasswordViewModel>(),
          child: const ForgetPasswordView(),
        ),
      );

    case AppRoutes.orderDetails:
      {
        var cubit = getIt.get<OrderItemNameCubit>();
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<OrderItemNameCubit>(
            create: (context) => cubit,
            child: OrderDetailsView(),
          ),
        );
      }

    case AppRoutes.updateDriverView:
      return MaterialPageRoute(
        settings: RouteSettings(arguments: settings.arguments),
        builder: (_) => BlocProvider(
          create: (_) => getIt<UpdateProfileViewModel>(),
          child: const UpdateDriverView(),
        ),
      );

    case AppRoutes.applySuccessView:
      return MaterialPageRoute(builder: (context) => const ApplySuccessView());

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
