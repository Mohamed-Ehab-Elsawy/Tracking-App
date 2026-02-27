import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class ApplySuccessView extends StatelessWidget {
  const ApplySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(AssetConstants.checkCircle),
          Text(
            'successTitle'.tr(),
            style: context.textStyles.semiBold18,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'successDesc'.tr(),
            textAlign: TextAlign.center,
            style: context.textStyles.regular16,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.loginView);
              },
              child: Text('login'.tr()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,

            child: Image.asset(
              AssetConstants.backgroundPath,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
