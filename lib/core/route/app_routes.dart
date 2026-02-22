import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/home/presentation/view/home_view.dart';

class AppRoutes {
  // Define app routes
  static const String initialRoute = '/';
  static const String home = '/home_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.initialRoute:
      return MaterialPageRoute(builder: (context) => const Scaffold());
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              getIt<OrdersViewModel>()..doIntent(GetOrdersIntent()),
          child: const HomeView(),
        ),
      );
  }
  return null;
}
