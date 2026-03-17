import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';

class CurrentOrderStatusCard extends StatelessWidget {
  final ActiveOrderDto entity;
  final String currentState;

  const CurrentOrderStatusCard({
    super.key,
    required this.entity,
    required this.currentState,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Card(
      color: colors.lightPink,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "status".tr() + currentState.tr(),
              style: textStyles.semiBold18.copyWith(color: colors.success),
            ),
            Text(
              "order_id".tr() + entity.orderId.toString(),
              style: textStyles.semiBold18.copyWith(color: colors.surface),
            ),
            Text(
              entity.startedAt.toString(),
              style: textStyles.medium13.copyWith(color: colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
