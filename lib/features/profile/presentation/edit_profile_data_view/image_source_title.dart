import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ImageSourceTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: context.colors.lightPink,
        child: Icon(icon, color: context.colors.primary),
      ),
      title: Text(title, style: context.textStyles.medium16),
      onTap: onTap,
    );
  }
}
