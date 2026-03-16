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
import 'package:tracking_app/features/auth/presentation/login/login_view.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/onboarding/view/onboarding_view.dart';
import 'package:tracking_app/features/order_details/domain/entities/order_entity.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/order_details/presentation/map_view.dart';
import 'package:tracking_app/features/order_details/presentation/order_delivery_success_view.dart';
import 'package:tracking_app/features/order_details/presentation/order_details_view.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view/order_details_view.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view/update_driver_view.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';
import 'package:tracking_app/features/sections/presentation/sections_view.dart';

class AppRoutes {
  // Define app routes
  static const String initialRoute = '/';
  static const String home = '/home_view';
  static const String onboardingView = '/onboarding_view';
  static const String loginView = '/login_view';
  static const String applyView = '/apply_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String homeView = '/home';
  static const String orderHistory = '/orderHistory';
  static const String orderDetails = '/orderDetails';
  static const String changePassword = '/change_password';
  static const String applySuccessView = '/apply_success_view';
  static const String profileView = '/profile_view';
  static const String updateDriverView = '/update_driver_view';
  static const String orderDetailsView = '/order_details_view';
  static const String mapOrderView = "mapOrderView";
  static const String orderDeliverySuccessView = "orderDeliverySuccessView";
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.onboardingView:
      return MaterialPageRoute(builder: (context) => const OnboardingView());
    case AppRoutes.mapOrderView:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider(
          create: (context) => getIt<MapOrderViewModel>(),
          child: MapOrderView(
            order:
                settings.arguments as OrderEntity? ??
                OrderEntity(
                  userAddress: 'userAddress',
                  userName: 'userName',
                  userPhone: 'userPhone',
                  storeAddress: 'storeAddress',
                  storeName: 'storeName',
                  storePhone: 'storePhone',
                ),
          ),
        ),
      );

    case AppRoutes.orderDeliverySuccessView:
      return MaterialPageRoute(
        builder: (context) => const OrderDeliverySuccessView(),
      );

    case AppRoutes.loginView:
      var cubit = getIt.get<LoginCubit>();
      return MaterialPageRoute(
        builder: (context) =>
            BlocProvider(create: (context) => cubit, child: const LoginView()),
      );

    case AppRoutes.forgetPasswordView:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<ForgetPasswordViewModel>(
          create: (context) => getIt.get<ForgetPasswordViewModel>(),
          child: const ForgetPasswordView(),
        ),
      );

    case AppRoutes.applyView:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              getIt<ApplyViewModel>()..doIntent(GetVehiclesIntent()),
          child: const ApplyView(),
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

    case AppRoutes.homeView:
      var sectionsCubit = SectionsCubit();
      var profileViewModel = getIt<ProfileViewModel>()
        ..doIntent(GetDriverDataEvent());
      var logoutCubit = getIt.get<LogoutCubit>();
      var orderHistoryCubit = getIt.get<OrderHistoryCubit>();
      var homeViewModel = getIt<OrdersViewModel>();
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<SectionsCubit>(create: (context) => sectionsCubit),
            BlocProvider<LogoutCubit>(create: (context) => logoutCubit),
            BlocProvider<ProfileViewModel>(
              create: (context) => profileViewModel,
            ),
            BlocProvider<OrderHistoryCubit>(
              create: (context) => orderHistoryCubit,
            ),
            BlocProvider<OrdersViewModel>(
              create: (context) => homeViewModel..doIntent(GetOrdersIntent()),
            ),
          ],
          child: const SectionsView(),
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

    case AppRoutes.orderDetailsView:
      var cubit = getIt.get<CurrentOrderDetailsCubit>();
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => cubit..doIntent(GetCurrentOrderDetailsIntent()),
          child: const CurrentOrderDetailsView(),
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
  }
  return null;
}
