import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/core/widgets/loading_indicator.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_recovery_controller.dart';

class PasswordResetStep extends StatefulWidget {
  const PasswordResetStep({
    super.key,
    required this.passwordRecoveryController,
  });
  final PasswordRecoveryController passwordRecoveryController;

  @override
  State<PasswordResetStep> createState() => _PasswordResetStepState();
}

class _PasswordResetStepState extends State<PasswordResetStep> {
  late final StreamSubscription streamEvent;
  @override
  void initState() {
    super.initState();
    streamEvent = context.read<ForgetPasswordViewModel>().eventStream.listen((
      events,
    ) {
      if (events is ConfirmPasswordEvent && mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.loginView, (route) => false);
      }
      if (events is ShowSnackBarEvent && mounted) {
        AppSnackBar.show(context, events.message, isError: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = context.textStyles;
    var color = context.colors;
    return Form(
      key: widget.passwordRecoveryController.confirmPasswordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.h(40),
          Text(
            "forgetPassword.resetPassword".tr(),
            style: textStyle.medium16.copyWith(fontSize: 18),
          ),
          context.h(16),
          Text(
            "forgetPassword.ResetPasswordDesc".tr(),
            textAlign: TextAlign.center,
            style: textStyle.regular14.copyWith(color: color.grey),
          ),
          context.h(32),
          _passwordField(),
          context.h(48),
          _confirmButton(),
        ],
      ),
    );
  }

  _passwordField() => TextFormField(
    controller: widget.passwordRecoveryController.newPasswordController,
    decoration: InputDecoration(
      hintText: "forgetPassword.newPasswordHint".tr(),
      label: Text("forgetPassword.newPasswordLabel".tr()),
    ),
  );

  _confirmButton() => BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
    builder: (context, state) {
      return AbsorbPointer(
        absorbing: state.resetPasswordState!.isLoading,
        child: ElevatedButton(
          onPressed: _resetPasswordClicked,
          child: (state.resetPasswordState!.isLoading)
              ? LoadingIndicator()
              : Text("forgetPassword.confirmBtn".tr()),
        ),
      );
    },
  );

  void _resetPasswordClicked() {
    if (widget.passwordRecoveryController.confirmPasswordFormKey.currentState!
        .validate()) {
      String newPassword = widget
          .passwordRecoveryController
          .newPasswordController
          .text
          .trim();
      var user = context.read<ForgetPasswordViewModel>().state.user!.copyWith(
        password: newPassword,
        code: null,
      );
      context.read<ForgetPasswordViewModel>().doIntent(
        ConfirmPasswordIntent(user: user),
      );
    }
  }
}
