import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class OrderDeliverySuccessView extends StatelessWidget {
  const OrderDeliverySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colors;
    final textTheme = context.textStyles;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(AssetConstants.successCheck, width: 200),
            context.h(32),
            Text(
              "thanks".tr(),
              style: textTheme.medium20.copyWith(
                fontSize: 24,
                color: color.success,
              ),
            ),
            Text(
              "success_delivered".tr(),
              textAlign: TextAlign.center,
              style: textTheme.medium20.copyWith(fontSize: 24),
            ),
            context.h(48),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.homeView, (route) => false);
                //! Delete Cache
              },
              child: Text("done".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
