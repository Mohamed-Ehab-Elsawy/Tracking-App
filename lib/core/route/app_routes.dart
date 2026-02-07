import 'package:flutter/material.dart';

class AppRoutes {
  // Define app routes
  static const String initialRoute = '/';
  //static const String home = '/home_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.initialRoute:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
  return null;
}
