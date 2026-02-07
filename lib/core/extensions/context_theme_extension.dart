import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_theme.dart';

extension ThemeExtensionX on BuildContext {
  AppTheme get theme => AppTheme.of(this);
}
