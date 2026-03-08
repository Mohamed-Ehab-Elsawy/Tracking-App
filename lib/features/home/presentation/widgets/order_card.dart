import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/home/domain/entities/home_order_entity.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/home/presentation/widgets/store_and_user_card.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.onReject});
  final HomeOrderEntity? order;

  final void Function()? onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      color: context.theme.colors.secondary,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 1,
      margin: const EdgeInsets.all(10),

      child: Container(
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("flowerOrder".tr(), style: context.textStyles.medium13),
            SizedBox(height: 10),
            Text(
              "pickupAddress".tr(),
              style: context.textStyles.regular12.copyWith(
                color: context.theme.colors.grey,
              ),
            ),
            StoreAndUserCard(
              image: order?.storeImage,
              name: order?.storeName,
              address: order?.storeAddress,
            ),
            SizedBox(height: 10),
            Text(
              "userAddress".tr(),
              style: context.textStyles.regular12.copyWith(
                color: context.theme.colors.grey,
              ),
            ),
            StoreAndUserCard(
              image: order?.userImage,
              name: order?.userName,
              address: order?.userAddress,
            ),
            SizedBox(height: 10),

            Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "EGP ${order?.totalPrice.toString()}",
                    style: context.textStyles.semiBold18,
                  ),
                ),

                SizedBox(
                  width: 111,
                  height: 36,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: context.theme.colors.primary),
                    ),
                    onPressed: () {
                      if (order != null) {
                        context.read<OrdersViewModel>().doIntent(
                          RejectOrderIntent(orderId: order!.orderId!),
                        );
                      }
                    },
                    child: Text(
                      'reject'.tr(),
                      style: context.textStyles.medium13.copyWith(
                        color: context.theme.colors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 111,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('accept'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
