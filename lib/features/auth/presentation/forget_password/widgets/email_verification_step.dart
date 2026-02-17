import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/core/widgets/loading_indicator.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
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
  late final StreamSubscription<ForgetPasswordUiEvent> streamEvent;

  @override
  void initState() {
    super.initState();
    streamEvent = context
        .read<ForgetPasswordViewModel>()
        .navigationStream
        .listen((events) {
          if (events is ConfirmEmailEvent) {
            widget.passwordRecoveryController.pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
          if (events is ShowSnackBarEvent && mounted) {
            AppSnackBar.show(context, events.message, isError: true);
          }
        });
  }

  @override
  void dispose() {
    streamEvent.cancel();
    super.dispose();
  }

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
          _confirmButton(),
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

  _confirmButton() => BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
    builder: (context, state) {
      return AbsorbPointer(
        absorbing: state.emailVerificationState!.isLoading,
        child: ElevatedButton(
          onPressed: _confirmClicked,
          child: (state.emailVerificationState!.isLoading)
              ? LoadingIndicator()
              : Text("forgetPassword.confirmBtn".tr()),
        ),
      );
    },
  );

  void _confirmClicked() {
    if (widget.passwordRecoveryController.emailFormKey.currentState!
        .validate()) {
      String email = widget.passwordRecoveryController.emailController.text
          .trim();
      UserEntity user = context
          .read<ForgetPasswordViewModel>()
          .state
          .user!
          .copyWith(email: email);
      context.read<ForgetPasswordViewModel>().doAction(
        EmailVerificationIntent(user: user),
      );
    }
  }
}
