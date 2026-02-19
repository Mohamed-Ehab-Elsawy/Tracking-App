import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class MainProfileItem extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String title;
  final VoidCallback? onTap;

  const MainProfileItem({
    super.key,
    required this.title,
    required this.onTap,
    this.prefix,
    this.suffix = const Icon(Icons.navigate_next_rounded, size: 24),
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefix ?? const SizedBox.shrink(),
          prefix != null ? const SizedBox(width: 4) : const SizedBox.shrink(),
          Text(title, style: context.textStyles.regular14),
          const Spacer(),
          suffix ?? const SizedBox.shrink(),
        ],
      ),
    ),
  );
}
