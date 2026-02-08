import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_recovery_controller.dart';

class PasswordResetStep extends StatelessWidget {
  const PasswordResetStep({
    super.key,
    required this.passwordRecoveryController,
  });
  final PasswordRecoveryController passwordRecoveryController;
  @override
  Widget build(BuildContext context) {
    var textStyle = context.textStyles;
    var color = context.colors;
    return Form(
      key: passwordRecoveryController.confirmPasswordFormKey,
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
          context.h(24),
          _confirmPasswordField(),
          context.h(48),
          _confirmButton(),
        ],
      ),
    );
  }

  _passwordField() => TextFormField(
    controller: passwordRecoveryController.newPasswordController,
    decoration: InputDecoration(
      hintText: "forgetPassword.newPasswordHint".tr(),
      label: Text("forgetPassword.newPasswordLabel".tr()),
    ),
  );

  _confirmPasswordField() => TextFormField(
    controller: passwordRecoveryController.newPasswordConfirmationController,
    decoration: InputDecoration(
      hintText: "forgetPassword.confirmPasswordHint".tr(),
      label: Text("forgetPassword.confirmPasswordLabel".tr()),
    ),
  );

  _confirmButton() => ElevatedButton(
    onPressed: () {
      if (passwordRecoveryController.confirmPasswordFormKey.currentState!
          .validate()) {}
    },
    child: Text("forgetPassword.confirmBtn".tr()),
  );
}
