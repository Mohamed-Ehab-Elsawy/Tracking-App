import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/app_colors.dart';

abstract class AppTheme {
  AppColors get colors;

  FilledButtonThemeData get filledButtonThemeData;

  ThemeData get themeData;

  OutlinedButtonThemeData get outlinedButtonThemeData;

  BottomNavigationBarThemeData get bottomAppBarThemeData;

  ElevatedButtonThemeData get elevatedButtonThemeData;

  InputDecorationTheme get inputDecorationTheme;

  CheckboxThemeData get checkboxThemeData;

  AppBarTheme get appBarTheme;

  static AppTheme of(BuildContext context) => _AppThemeProvider.of(context);
}

class _AppThemeProvider extends InheritedWidget {
  final AppTheme appTheme;

  const _AppThemeProvider({required this.appTheme, required super.child});

  static AppTheme of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_AppThemeProvider>();
    if (provider != null) {
      return provider.appTheme;
    }

    throw FlutterError(
      'AppTheme not found in context. '
      'Make sure to wrap your app with AppThemeProvider.',
    );
  }

  @override
  bool updateShouldNotify(_AppThemeProvider oldWidget) {
    return appTheme != oldWidget.appTheme;
  }
}

class AppThemeProvider extends StatelessWidget {
  final AppTheme appTheme;
  final Widget child;

  const AppThemeProvider({
    super.key,
    required this.appTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _AppThemeProvider(appTheme: appTheme, child: child);
  }
}
