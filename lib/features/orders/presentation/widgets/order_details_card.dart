import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class OrderDetailsCard extends StatelessWidget {
  final String? name;
  final int? price;
  final int? quantity;
  final String? imagePath;

  const OrderDetailsCard({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Row(
          children: [
            CustomImageView(
              width: 70,
              height: 70,
              radius: const BorderRadius.all(Radius.circular(40)),
              imagePath: imagePath,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name ?? "un known name".tr(),
                        style: context.textStyles.regular14.copyWith(
                          color: context.colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "X${quantity ?? 0}",
                        style: context.textStyles.regular14.copyWith(
                          color: context.colors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "EGP ${price ?? 0}",
                    style: context.textStyles.medium16.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
