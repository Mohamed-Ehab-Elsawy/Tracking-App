import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/model/app_dialog_action.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

/*
                               ** Usage example **
  AppDialog.show(
    context,
    title: 'Login Required',
    message: 'Please login to continue.',
    icon: Icons.lock_outline,
    iconColor: Colors.orange,
    actions: [
      AppDialogAction.outlined(
        label: 'Cancel',
        onPressed: context.pop,
      ),
      AppDialogAction.primary(
       label: 'Login',
        onPressed: () => context.pushNamedAndRemoveUntil(AppRoutes.login)
      ),
    ],
  );
*/

class AppDialog {
  AppDialog._(); // coverage:ignore-line

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? iconColor,
    bool barrierDismissible = false,
    List<AppDialogAction> actions = const [],
  }) => showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              _DialogIcon(
                icon: icon,
                color: iconColor ?? context.colors.primary,
              ),

            if (icon != null) context.h(16),

            Text(title, style: context.textStyles.semiBold24),
            context.h(8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textStyles.medium16.copyWith(
                color: context.colors.grey,
              ),
            ),

            if (actions.isNotEmpty) context.h(24),

            if (actions.isNotEmpty) _DialogActions(actions: actions),
          ],
        ),
      ),
    ),
  );
}

class _DialogIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _DialogIcon({
    required this.icon,
    required this.color,
  }); // coverage:ignore-line

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: color, size: 32),
  );
}

class _DialogActions extends StatelessWidget {
  final List<AppDialogAction> actions;

  const _DialogActions({required this.actions}); // coverage:ignore-line

  @override
  Widget build(BuildContext context) => Row(
    spacing: 12,
    children: actions.map((action) {
      return Expanded(
        child: action.isPrimary
            ? ElevatedButton(
                onPressed: action.onPressed,
                child: Text(action.label),
              )
            : OutlinedButton(
                onPressed: action.onPressed,
                child: Text(action.label),
              ),
      );
    }).toList(),
  );
}
