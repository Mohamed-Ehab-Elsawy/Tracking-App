import 'package:flutter/material.dart';

extension AppNavigatorExtension on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  void pushNamedAndRemoveUntil(String routeName) =>
      Navigator.of(this).pushNamedAndRemoveUntil(routeName, (_) => false);

  void pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
}
