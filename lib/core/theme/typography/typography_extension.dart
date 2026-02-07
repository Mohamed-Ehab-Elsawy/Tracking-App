import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/typography/app_typography.dart';

/// Usage:
/// ```dart
/// Text('Hello', style: context.textStyles.semiBold24)
/// Text('World', style: context.textStyles.regular16)
/// ```
extension TypographyExtension on BuildContext {
  ThemedTextStyles get textStyles {
    final appTheme = AppTheme.of(this);
    final textColor = appTheme.colors.textColor;

    return ThemedTextStyles(textColor: textColor);
  }
}

class ThemedTextStyles {
  final Color textColor;

  const ThemedTextStyles({required this.textColor});

  // Headlines
  TextStyle get semiBold24 =>
      AppTypography.semiBold24.copyWith(color: textColor);
  TextStyle get medium20 => AppTypography.medium20.copyWith(color: textColor);

  // Titles
  TextStyle get semiBold18 =>
      AppTypography.semiBold18.copyWith(color: textColor);
  TextStyle get medium16 => AppTypography.medium16.copyWith(color: textColor);
  TextStyle get medium13 => AppTypography.medium13.copyWith(color: textColor);

  // Body
  TextStyle get regular16 => AppTypography.regular16.copyWith(color: textColor);
  TextStyle get regular14 => AppTypography.regular14.copyWith(color: textColor);
  TextStyle get regular12 => AppTypography.regular12.copyWith(color: textColor);

  // Labels
  TextStyle get semiBold12 =>
      AppTypography.semiBold12.copyWith(color: textColor);
}
