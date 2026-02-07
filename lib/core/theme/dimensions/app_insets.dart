import 'package:flutter/widgets.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';

class AppInsets {
  const AppInsets._(); // coverage:ignore-line

  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );
}
