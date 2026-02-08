import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/custom_rich_text.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/otp_widget.dart';

class CodeVerificationStep extends StatelessWidget {
  const CodeVerificationStep({super.key});

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
        OTPWidget(hasError: false, isLoading: false),
        context.h(24),
        CustomRichText(
          underLineText: "forgetPassword.resend".tr(),
          baseText: "forgetPassword.didNotReceiveCode".tr(),
          onTap: () {},
        ),
      ],
    );
  }
}
