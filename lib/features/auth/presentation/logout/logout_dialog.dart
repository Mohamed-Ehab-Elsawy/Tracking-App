import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_navigation_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_dialog.dart';
import 'package:tracking_app/core/presentation/feedback/model/app_dialog_action.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/features/auth/presentation/logout/logout_cubit.dart';

showLogoutDialog(BuildContext context) {
  AppDialog.show(
    context,
    title: 'logout'.tr().toUpperCase(),
    message: 'confirm_logout_message'.tr(),
    icon: Icons.logout_rounded,
    iconColor: context.colors.error,
    actions: [
      AppDialogAction.outlined(label: 'cancel'.tr(), onPressed: context.pop),
      AppDialogAction.primary(
        label: 'logout'.tr(),
        onPressed: () {
          context.read<LogoutCubit>().doIntent(DriverLogoutIntent());
          context.pushNamedAndRemoveUntil(AppRoutes.onboardingView);
        },
      ),
    ],
  );
}
