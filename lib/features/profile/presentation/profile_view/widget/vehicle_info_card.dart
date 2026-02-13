import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class VehicleInfoCard extends StatelessWidget {
  final String? vehicleType;
  final String? vehicleNumber;
  final VoidCallback? onTap;
  const VehicleInfoCard({
    super.key,
    this.vehicleType,
    this.vehicleNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: context.colors.backgroundColor,
      elevation: 2,

      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle info".tr(),
                  style: context.textStyles.medium20.copyWith(fontSize: 16),
                ),
                Text(
                  vehicleType ?? "unknown Type".tr(),
                  style: context.textStyles.regular16,
                ),
                Text(
                  vehicleNumber ?? "unknown Number".tr(),
                  style: context.textStyles.regular16,
                ),
              ],
            ),
            Spacer(),
            InkWell(onTap: onTap, child: Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }
}
