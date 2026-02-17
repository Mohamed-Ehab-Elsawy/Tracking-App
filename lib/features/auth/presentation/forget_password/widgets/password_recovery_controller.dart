import 'package:flutter/material.dart';

class PasswordRecoveryController {
  PageController pageController;
  TextEditingController emailController;
  TextEditingController newPasswordController;
  GlobalKey<FormState> emailFormKey;
  GlobalKey<FormState> confirmPasswordFormKey;

  PasswordRecoveryController()
    : pageController = PageController(initialPage: 0),
      emailController = TextEditingController(),
      newPasswordController = TextEditingController(),
      emailFormKey = GlobalKey<FormState>(),

      confirmPasswordFormKey = GlobalKey<FormState>();

  void dispose() {
    pageController.dispose();
    emailController.dispose();
    newPasswordController.dispose();
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }
}
