import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view/order_details.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view/order_history_view.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';

class AppRoutes {
  // Define app routes
  static const String initialRoute = '/';
  //static const String home = '/home_view';
  static const String orderHistory = '/orderHistory';
  static const String orderDetails = '/orderDetails';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.initialRoute:
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
