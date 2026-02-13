import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/features/sections/presentation/managers/sections_cubit.dart';
import 'package:tracking_app/features/sections/presentation/sections_view.dart';

class AppRoutes {
  // Define app routes
  static const String home = '/home_view';
}

Route? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (context) => BlocProvider<SectionsCubit>(
          create: (context) => SectionsCubit(),
          child: const SectionsView(),
        ),
      );
  }
  return null;
}
