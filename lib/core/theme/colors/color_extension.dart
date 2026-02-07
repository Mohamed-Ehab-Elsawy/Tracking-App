import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/colors/app_colors.dart';

/// Usage:
/// ```dart
/// context.colors.primary
/// context.colors.error
/// ```
extension ColorExtension on BuildContext {
  AppColors get colors {
    final appTheme = AppTheme.of(this);
    return appTheme.colors;
  }
}
