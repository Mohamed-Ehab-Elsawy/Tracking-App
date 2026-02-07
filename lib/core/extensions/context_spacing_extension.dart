import 'package:flutter/material.dart';

extension AppSpacingExtensionX on BuildContext {
  double get _screenH => MediaQuery.of(this).size.height;
  double get _screenW => MediaQuery.of(this).size.width;

  Widget h(double value) => SizedBox(height: _screenH * (value / 812));

  Widget w(double value) => SizedBox(width: _screenW * (value / 375));
}
