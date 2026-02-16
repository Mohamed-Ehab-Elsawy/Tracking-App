import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/address_card.dart';

class OrderCard extends StatelessWidget {
  String? orderNumber;
  String? status;
  String? shopImagePath;
  String? shopAddress;
  String? shopName;
  String? userImagePath;
  String? userAddress;
  String? userName;
  OrderCard({
    super.key,
    required this.orderNumber,
    required this.status,
    required this.shopImagePath,
    required this.shopAddress,
    required this.shopName,
    required this.userImagePath,
    required this.userAddress,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Flower order".tr(),
              style: context.textStyles.medium16.copyWith(color: Colors.grey),
            ).tr(),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  status == "completed"
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  color: status == "completed" ? Colors.green : Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  status ?? "un know state".tr(),
                  style: status == "completed"
                      ? context.textStyles.medium20.copyWith(
                          color: Colors.green,
                        )
                      : context.textStyles.medium20.copyWith(color: Colors.red),
                ),
                Spacer(),
                Text(
                  orderNumber ?? "un know number".tr(),
                  style: context.textStyles.semiBold12.copyWith(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Pickup address", style: context.textStyles.regular14).tr(),
            SizedBox(height: 10),
            AddressCard(
              imagePath: shopImagePath,
              address: shopAddress,
              name: shopName,
            ),
            SizedBox(height: 20),
            Text("User address", style: context.textStyles.regular12).tr(),
            SizedBox(height: 10),
            AddressCard(
              imagePath: userImagePath,
              address: userAddress,
              name: userName,
            ),
          ],
        ),
      ),
    );
  }
}
