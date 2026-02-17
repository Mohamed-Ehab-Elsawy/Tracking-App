import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title, style: context.textStyles.medium20));
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}
