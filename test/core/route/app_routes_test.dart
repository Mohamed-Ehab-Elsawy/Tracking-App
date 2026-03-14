import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';

class _FakeLoginCubit extends Fake implements LoginCubit {}

class _FakeForgetPasswordViewModel extends Fake
    implements ForgetPasswordViewModel {}

class _FakeApplyViewModel extends Fake implements ApplyViewModel {}

class _FakeChangePasswordViewModel extends Fake
    implements ChangePasswordViewModel {}

class _FakeLogoutCubit extends Fake implements LogoutCubit {}

class _FakeOrderHistoryCubit extends Fake implements OrderHistoryCubit {}

class _FakeOrdersViewModel extends Fake implements OrdersViewModel {}

class _FakeProfileViewModel extends Fake implements ProfileViewModel {}

class _FakeUpdateProfileViewModel extends Fake
    implements UpdateProfileViewModel {}

class _FakeCurrentOrderDetailsCubit extends Fake
    implements CurrentOrderDetailsCubit {}

class _FakeOrderItemNameCubit extends Fake implements OrderItemNameCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LoginCubit>(_FakeLoginCubit());
    getIt.registerSingleton<ForgetPasswordViewModel>(
      _FakeForgetPasswordViewModel(),
    );
    getIt.registerSingleton<ApplyViewModel>(_FakeApplyViewModel());
    getIt.registerSingleton<ChangePasswordViewModel>(
      _FakeChangePasswordViewModel(),
    );
    getIt.registerSingleton<LogoutCubit>(_FakeLogoutCubit());
    getIt.registerSingleton<OrderHistoryCubit>(_FakeOrderHistoryCubit());
    getIt.registerSingleton<OrdersViewModel>(_FakeOrdersViewModel());
    getIt.registerSingleton<ProfileViewModel>(_FakeProfileViewModel());
    getIt.registerSingleton<UpdateProfileViewModel>(
      _FakeUpdateProfileViewModel(),
    );
    getIt.registerSingleton<CurrentOrderDetailsCubit>(
      _FakeCurrentOrderDetailsCubit(),
    );
    getIt.registerSingleton<OrderItemNameCubit>(_FakeOrderItemNameCubit());
  });

  test('onboarding route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.onboardingView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('login route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.loginView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('forget password route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.forgetPasswordView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('apply view route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.applyView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('apply success view route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.applySuccessView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('change password route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.changePassword);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test('home view route returns MaterialPageRoute with MultiBlocProvider', () {
    final settings = const RouteSettings(name: AppRoutes.homeView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test(
    'update driver view route returns MaterialPageRoute and preserves arguments',
    () {
      final args = {'key': 'value', 'id': 42};
      final settings = RouteSettings(
        name: AppRoutes.updateDriverView,
        arguments: args,
      );
      final route = onGenerateRoute(settings);
      expect(route, isA<MaterialPageRoute>());
      final materialRoute = route as MaterialPageRoute;
      expect(materialRoute.settings.arguments, equals(args));
    },
  );

  test('current order details view route returns MaterialPageRoute', () {
    final settings = const RouteSettings(name: AppRoutes.orderDetailsView);
    final route = onGenerateRoute(settings);
    expect(route, isA<MaterialPageRoute>());
  });

  test(
    'orders order details route returns MaterialPageRoute and carries settings',
    () {
      final args = {'orderId': 'ORD-1'};
      final settings = RouteSettings(
        name: AppRoutes.orderDetails,
        arguments: args,
      );
      final route = onGenerateRoute(settings);
      expect(route, isA<MaterialPageRoute>());
      final materialRoute = route as MaterialPageRoute;
      expect(materialRoute.settings.arguments, equals(args));
    },
  );

  test('unknown route returns null', () {
    final settings = const RouteSettings(name: '/unknown_route');
    final route = onGenerateRoute(settings);
    expect(route, isNull);
  });

  test('AppRoutes constants are defined', () {
    expect(AppRoutes.initialRoute, isA<String>());
    expect(AppRoutes.home, isA<String>());
    expect(AppRoutes.onboardingView, isA<String>());
    expect(AppRoutes.loginView, isA<String>());
    expect(AppRoutes.applyView, isA<String>());
    expect(AppRoutes.forgetPasswordView, isA<String>());
    expect(AppRoutes.homeView, isA<String>());
    expect(AppRoutes.orderHistory, isA<String>());
    expect(AppRoutes.orderDetails, isA<String>());
    expect(AppRoutes.changePassword, isA<String>());
    expect(AppRoutes.applySuccessView, isA<String>());
    expect(AppRoutes.profileView, isA<String>());
    expect(AppRoutes.updateDriverView, isA<String>());
    expect(AppRoutes.orderDetailsView, isA<String>());
  });
}
