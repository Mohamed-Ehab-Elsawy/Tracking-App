import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';

class AppSnackBar {
  AppSnackBar._(); // coverage:ignore-line

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? context.colors.error
              : context.colors.success,
          content: Text(message, textAlign: TextAlign.center),
          duration: duration,
        ),
      );
  }
}
