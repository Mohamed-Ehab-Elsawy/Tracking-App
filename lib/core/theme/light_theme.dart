import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/theme_constants.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/core/theme/colors/app_colors.dart';
import 'package:tracking_app/core/theme/colors/light_colors.dart';
import 'package:tracking_app/core/theme/theme_extension.dart';
import 'package:tracking_app/core/theme/typography/app_typography.dart';

class LightTheme extends AppTheme {
  /// Singleton instance
  static final LightTheme _instance = LightTheme._internal();

  factory LightTheme() => _instance;

  LightTheme._internal();

  @override
  AppColors get colors => const LightColors();

  @override
  RadioThemeData get radioThemeData => RadioThemeData(
    fillColor: WidgetStateProperty.all(colors.primary),
    overlayColor: WidgetStateProperty.all(colors.secondary),
    visualDensity: VisualDensity.compact,
  );

  @override
  CheckboxThemeData get checkboxThemeData => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return colors.primary;
      }
      return colors.secondary;
    }),
    overlayColor: WidgetStateProperty.all(colors.secondary),
    visualDensity: VisualDensity.compact,
    side: BorderSide(color: colors.grey, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty.all(colors.secondary),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  SwitchThemeData get switchThemeData => SwitchThemeData(
    thumbColor: WidgetStateProperty.all(colors.secondary),
    trackColor: WidgetStateProperty.all(colors.primary),
  );

  TabBarThemeData get tabBarThemeData => TabBarThemeData(
    labelColor: colors.primary,
    unselectedLabelColor: Colors.grey,
    indicatorSize: TabBarIndicatorSize.label,
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    dividerColor: Colors.transparent,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: colors.primary, width: 3),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      insets: const EdgeInsets.symmetric(vertical: 8),
    ),
    tabAlignment: TabAlignment.start,
  );

  @override
  BottomNavigationBarThemeData get bottomAppBarThemeData =>
      BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: _textStyle(AppTypography.regular12),
        selectedLabelStyle: _textStyle(AppTypography.regular12),
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.secondary[80],
        backgroundColor: colors.secondary,
      );

  @override
  ThemeData get themeData => ThemeData(
    brightness: Brightness.light,
    switchTheme: switchThemeData,
    fontFamily: ThemeConstants.fontFamily,
    useMaterial3: true,
    filledButtonTheme: filledButtonThemeData,
    inputDecorationTheme: inputDecorationTheme,
    elevatedButtonTheme: elevatedButtonThemeData,
    bottomNavigationBarTheme: bottomAppBarThemeData,
    scaffoldBackgroundColor: colors.backgroundColor,
    outlinedButtonTheme: outlinedButtonThemeData,
    checkboxTheme: checkboxThemeData,
    primarySwatch: materialColorWithStandardShades(colors.primary),
    appBarTheme: appBarTheme,
    tabBarTheme: tabBarThemeData,
    radioTheme: radioThemeData,
  );

  @override
  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: colors.surface[30],
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: colors.primary,
          foregroundColor: colors.secondary,
          textStyle: _textStyle(AppTypography.medium16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          side: BorderSide(color: colors.grey, width: 2),
          foregroundColor: colors.grey,
          textStyle: _textStyle(AppTypography.medium16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: colors.grey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: colors.error),
    ),
    prefixIconColor: colors.secondary[70],
    labelStyle: TextStyle(color: colors.grey),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: colors.grey),
    ),
    hintStyle: _textStyle(
      AppTypography.regular14,
    ).copyWith(color: colors.secondary[70]),
  );

  @override
  FilledButtonThemeData get filledButtonThemeData => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: colors.primary,
      foregroundColor: colors.secondary,
      textStyle: _textStyle(AppTypography.medium16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    ),
  );

  @override
  AppBarTheme get appBarTheme => AppBarTheme(
    foregroundColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: const IconThemeData(size: 20, color: Colors.black),
    titleTextStyle: _textStyle(AppTypography.medium20),
    centerTitle: false,
  );

  TextStyle _textStyle(TextStyle base) =>
      base.copyWith(color: colors.textColor);
}
