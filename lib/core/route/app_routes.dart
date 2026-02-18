import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/forget_password_view.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view/order_details.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view/order_history_view.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';

class AppRoutes {
  // Define app routes
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/signup_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home_view';
  static const String orderHistory = '/orderHistory';
  static const String orderDetails = '/orderDetails';
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
      {
        var cubit = getIt.get<OrderHistoryCubit>();
        return MaterialPageRoute(
          builder: (_) => BlocProvider<OrderHistoryCubit>(
            create: (context) => cubit,
            child: OrderHistoryView(),
          ),
        );
      }
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

    // case AppRoutes.orderHistory:
    //   return MaterialPageRoute(
    //     builder: (_) => BlocProvider<OrderHistoryCubit>.value(
    //       value: getIt.get<OrderHistoryCubit>(),
    //       child:  OrderHistoryView(),
    //     ),
    //   );
  }
  return null;
}
