import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

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
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: context.textStyles.medium16.copyWith(
              color: isError
                  ? context.colors.secondary
                  : context.colors.surface,
            ),
          ),
          duration: duration,
        ),
      );
  }
}
