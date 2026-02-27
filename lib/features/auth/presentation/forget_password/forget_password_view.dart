import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/widgets/app_bar.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/code_verification_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/email_verification_step.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_recovery_controller.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/widgets/password_reset_step.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final PasswordRecoveryController passwordRecoveryController;
  List<Widget> get pages => [
    EmailVerificationStep(
      passwordRecoveryController: passwordRecoveryController,
    ),
    CodeVerificationStep(
      passwordRecoveryController: passwordRecoveryController,
    ),
    PasswordResetStep(passwordRecoveryController: passwordRecoveryController),
  ];

  @override
  void initState() {
    super.initState();
    passwordRecoveryController = PasswordRecoveryController();
  }

  @override
  void dispose() {
    super.dispose();
    passwordRecoveryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "forgetPassword.password".tr()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              final controller = passwordRecoveryController.pageController;

              if (!controller.hasClients) return;

              final currentPage = controller.page?.round() ?? 0;

              if (currentPage == 0 || currentPage == 2) {
                Navigator.of(context).pop();
              }
              if (currentPage == 1) {
                passwordRecoveryController.previousPage();
              }
            },
            child: PageView(
              controller: passwordRecoveryController.pageController,
              physics: NeverScrollableScrollPhysics(),
              children: pages,
            ),
          ),
        ),
      ),
    );
  }
}
