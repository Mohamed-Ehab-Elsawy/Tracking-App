import 'package:flutter/material.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class OrderDetailsCard extends StatelessWidget {
  String name;
  int price;
  int quantity;

  OrderDetailsCard({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
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
              imagePath: "assets/images/splash_android_12.png",
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
                        name,
                        style: context.textStyles.regular14.copyWith(
                          color: context.colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "X$quantity",
                        style: context.textStyles.regular14.copyWith(
                          color: context.colors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "EGP $price",
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
