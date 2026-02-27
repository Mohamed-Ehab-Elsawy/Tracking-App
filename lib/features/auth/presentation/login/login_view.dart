import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/extensions/context_navigation_extension.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/dimensions/app_insets.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_contract.dart';
import 'package:tracking_app/features/auth/presentation/login/managers/login_cubit.dart';
import 'package:tracking_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:tracking_app/features/auth/presentation/widgets/remember_me_check_box.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _cubit = getIt.get<LoginCubit>();
  bool _rememberMe = false;
  String _emailText = '';
  String _passwordText = '';

  @override
  void initState() {
    super.initState();
    _cubit.eventStream.listen((event) {
      switch (event) {
        case LoginNavToHomeEvent():
          if (mounted) context.pushNamed(AppRoutes.homeView);
        case LoginNavToForgetPasswordEvent():
          if (mounted) context.pushNamed(AppRoutes.forgetPasswordView);
        case LoginFailureEvent():
          if (mounted) {
            AppSnackBar.show(
              context,
              event.errorMessage ?? 'errors.unknown'.tr(),
              isError: true,
            );
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('login'.tr(), style: context.textStyles.medium20),
    ),
    body: Padding(
      padding: AppInsets.screen,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              label: 'email'.tr(),
              hint: 'email_hint'.tr(),
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => FormValidators.email(value)?.tr(),
              onTextChange: (value) => _emailText = value,
            ),
            context.h(AppSpacing.md),
            CustomTextFormField(
              label: 'password'.tr(),
              hint: 'password_hint'.tr(),
              maxLines: 1,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              validator: (value) => FormValidators.password(value)?.tr(),
              onTextChange: (value) => _passwordText = value,
            ),
            Row(
              children: [
                RememberMeCheckBox(
                  isCheck: (value) => _rememberMe = value ?? false,
                ),
                Spacer(),
                TextButton(
                  onPressed: () =>
                      _cubit.emitEvent(LoginNavToForgetPasswordEvent()),
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.surface,
                  ),
                  child: Text(
                    'forgot_password'.tr(),
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            context.h(AppSpacing.md),
            BlocBuilder<LoginCubit, LoginViewState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state.loginState.isLoading) {
                  return SizedBox(
                    height: 50,
                    width: 50,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScale,
                      colors: context.colors.defaultRainbowColors,
                      strokeWidth: 1,
                      backgroundColor: context.colors.backgroundColor,
                      pathBackgroundColor: context.colors.surface,
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _cubit.doIntent(
                          DriverLoginIntent(
                            email: _emailText,
                            password: _passwordText,
                            rememberMe: _rememberMe,
                          ),
                        );
                      }
                    },
                    child: Text('continue'.tr()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
