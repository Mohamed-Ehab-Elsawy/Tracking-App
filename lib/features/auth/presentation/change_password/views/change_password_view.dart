import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/constants/keys_constants.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_intent.dart';
import 'package:tracking_app/features/auth/presentation/change_password/view_model/change_password_view_model.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  StreamSubscription<ChangePasswordUiIntent>? _uiEventsSubscription;

  @override
  void initState() {
    super.initState();
    _listenToUiIntent();
  }

  void _listenToUiIntent() {
    _uiEventsSubscription = context
        .read<ChangePasswordViewModel>()
        .uiEventsStream
        .listen((intent) {
          if (!mounted) return;
          switch (intent) {
            case ChangePasswordShowToast():
              AppSnackBar.show(
                context,
                intent.message,
                isError: intent.isError,
              );
            case PopScreenIntent():
              Navigator.pop(context);
          }
        });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _uiEventsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("changePassword".tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordController,
                validator: FormValidators.password,
                decoration: InputDecoration(
                  labelText: "password".tr(),
                  hintText: "enterCurrentPassword".tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              context.h(20),
              TextFormField(
                controller: _newPasswordController,
                validator: FormValidators.password,
                decoration: InputDecoration(
                  labelText: "newPassword".tr(),
                  hintText: "enterNewPassword".tr(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              context.h(40),
              BlocBuilder<ChangePasswordViewModel, ChangePasswordState>(
                builder: (context, state) {
                  final isLoading = state.changePasswordState.isLoading;
                  return ElevatedButton(
                    key: Key(KeysConstants.updatePasswordKey),
                    onPressed: isLoading ? null : confirmChangePassword,
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text("updatePassword".tr()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmChangePassword() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<ChangePasswordViewModel>().doIntent(
      ChangePasswordIntent(
        password: _passwordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      ),
    );
  }
}
