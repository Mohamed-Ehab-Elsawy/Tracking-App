import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/constants/keys_constants.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Image.asset(AssetConstants.deliveryMan, fit: BoxFit.contain),
              Text("welcomeTo".tr(), style: context.textStyles.medium20),
              Text("floweryRiderApp".tr(), style: context.textStyles.medium20),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const Key(KeysConstants.loginKey),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.loginView);
                },
                child: Text("login".tr()),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                key: const Key(KeysConstants.applyKey),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.applyView);
                },
                child: Text("apply".tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
