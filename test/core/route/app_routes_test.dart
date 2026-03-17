import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

class MockForgetPasswordVM extends Mock implements ForgetPasswordViewModel {}

class MockApplyVM extends Mock implements ApplyViewModel {}

class MockChangePasswordVM extends Mock implements ChangePasswordViewModel {}

class MockMapOrderVM extends Mock implements MapOrderViewModel {}

class MockLogoutCubit extends Mock implements LogoutCubit {}

class MockOrderHistoryCubit extends Mock implements OrderHistoryCubit {}

class MockOrdersVM extends Mock implements OrdersViewModel {}

class MockUpdateProfileVM extends Mock implements UpdateProfileViewModel {}

class MockOrderItemNameCubit extends Mock implements OrderItemNameCubit {}

class MockCurrentOrderDetailsCubit extends Mock
    implements CurrentOrderDetailsCubit {}

class MockProfileVM extends Mock implements ProfileViewModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(GetVehiclesIntent());
    registerFallbackValue(GetOrdersIntent());
    registerFallbackValue(GetDriverDataEvent());
    registerFallbackValue(GetCurrentOrderDetailsIntent());

    getIt.registerSingleton<LoginCubit>(MockLoginCubit());
    getIt.registerSingleton<ForgetPasswordViewModel>(MockForgetPasswordVM());
    getIt.registerSingleton<ApplyViewModel>(MockApplyVM());
    getIt.registerSingleton<ChangePasswordViewModel>(MockChangePasswordVM());
    getIt.registerSingleton<MapOrderViewModel>(MockMapOrderVM());
    getIt.registerSingleton<LogoutCubit>(MockLogoutCubit());
    getIt.registerSingleton<OrderHistoryCubit>(MockOrderHistoryCubit());
    getIt.registerSingleton<OrdersViewModel>(MockOrdersVM());
    getIt.registerSingleton<UpdateProfileViewModel>(MockUpdateProfileVM());
    getIt.registerSingleton<OrderItemNameCubit>(MockOrderItemNameCubit());
    getIt.registerSingleton<CurrentOrderDetailsCubit>(
      MockCurrentOrderDetailsCubit(),
    );
    getIt.registerSingleton<ProfileViewModel>(MockProfileVM());
  });

  RouteSettings tSettings(String name, [Object? args]) =>
      RouteSettings(name: name, arguments: args);

  test('map order view with args', () {
    final order = ActiveOrderDto(
      userAddress: "A",
      userName: "B",
      userPhoneNumber: "C",
      storeAddress: "D",
      storeName: "E",
      storePhoneNumber: "F",
    );

    final route = onGenerateRoute(tSettings(AppRoutes.mapOrderView, order));
    expect(route, isA<MaterialPageRoute>());
  });

  test('map order view without args uses default', () {
    final route = onGenerateRoute(tSettings(AppRoutes.mapOrderView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('login route', () {
    final route = onGenerateRoute(tSettings(AppRoutes.loginView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('forget password route', () {
    final route = onGenerateRoute(tSettings(AppRoutes.forgetPasswordView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('apply view route', () {
    final route = onGenerateRoute(tSettings(AppRoutes.applyView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('home view route', () {
    final route = onGenerateRoute(tSettings(AppRoutes.homeView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('update driver', () {
    final route = onGenerateRoute(tSettings(AppRoutes.updateDriverView, {}));
    expect(route, isA<MaterialPageRoute>());
  });

  test('order details view (new)', () {
    final route = onGenerateRoute(tSettings(AppRoutes.orderDetailsView));
    expect(route, isA<MaterialPageRoute>());
  });

  test('unknown route returns null', () {
    final route = onGenerateRoute(tSettings("/unknown"));
    expect(route, null);
  });
}
