import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/custom_rich_text.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/otp_widget.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_recovery_controller.dart';

class CodeVerificationStep extends StatefulWidget {
  const CodeVerificationStep({
    super.key,
    required this.passwordRecoveryController,
  });
  final PasswordRecoveryController passwordRecoveryController;

  @override
  State<CodeVerificationStep> createState() => _CodeVerificationStepState();
}

class _CodeVerificationStepState extends State<CodeVerificationStep> {
  late final StreamSubscription streamEvent;
  @override
  void initState() {
    super.initState();
    streamEvent = context
        .read<ForgetPasswordViewModel>()
        .navigationStream
        .listen((events) {
          if (events is SendCodeEvent) {
            widget.passwordRecoveryController.pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
          if (events is ReSendCodeEvent && mounted) {
            AppSnackBar.show(context, "forgetPassword.codeSend".tr());
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
    var textStyle = context.textStyles;
    var color = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        context.h(40),
        Text(
          "forgetPassword.emailVerification".tr(),
          style: textStyle.medium16.copyWith(fontSize: 18),
        ),
        context.h(16),
        Text(
          "forgetPassword.codeVerificationDesc".tr(),
          textAlign: TextAlign.center,
          style: textStyle.regular14.copyWith(color: color.grey),
        ),
        context.h(32),
        _otp(),
        context.h(24),
        CustomRichText(
          underLineText: "forgetPassword.resend".tr(),
          baseText: "forgetPassword.didNotReceiveCode".tr(),
          onTap: () {
            context.read<ForgetPasswordViewModel>().doAction(
              ReSendCodeIntent(
                user: context.read<ForgetPasswordViewModel>().state.user!,
              ),
            );
          },
        ),
      ],
    );
  }

  _otp() => BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
    builder: (context, state) {
      return OTPWidget(
        onCompleted: (pin) {
          context.read<ForgetPasswordViewModel>().doAction(
            CodeVerificationIntent(user: state.user!.copyWith(code: pin)),
          );
        },
        hasError: state.codeVerificationState!.isError,
        isLoading: state.codeVerificationState!.isLoading,
      );
    },
  );
}
