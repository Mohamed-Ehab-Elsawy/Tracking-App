import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/core/widgets/loading_indicator.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_recovery_controller.dart';

class EmailVerificationStep extends StatefulWidget {
  const EmailVerificationStep({
    super.key,
    required this.passwordRecoveryController,
  });
  final PasswordRecoveryController passwordRecoveryController;

  @override
  State<EmailVerificationStep> createState() => _EmailVerificationStepState();
}

class _EmailVerificationStepState extends State<EmailVerificationStep> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var theme = context.textStyles;
    var color = context.colors;
    return Form(
      key: widget.passwordRecoveryController.emailFormKey,
      child: Column(
        crossAxisAlignment: .center,
        children: [
          context.h(40),
          Text(
            "forgetPassword.forgetPassword".tr(),
            style: theme.medium16.copyWith(fontSize: 18),
          ),
          context.h(16),
          Text(
            "forgetPassword.emailVerificationDesc".tr(),
            style: theme.regular14.copyWith(color: color.grey),
            textAlign: .center,
          ),
          context.h(32),
          _emailField(),
          context.h(48),
          ElevatedButton(
            onPressed: () {
              if (widget.passwordRecoveryController.emailFormKey.currentState!
                  .validate()) {
                widget.passwordRecoveryController.nextPage();
              }
            },
            child: isLoading
                ? LoadingIndicator()
                : Text("forgetPassword.confirmBtn".tr()),
          ),
        ],
      ),
    );
  }

  _emailField() => TextFormField(
    controller: widget.passwordRecoveryController.emailController,
    validator: FormValidators.email,
    decoration: InputDecoration(
      hintText: "forgetPassword.emailHint".tr(),
      label: Text("forgetPassword.emailLabel".tr()),
    ),
  );
}
