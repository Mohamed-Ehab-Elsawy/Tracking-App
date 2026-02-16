import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/address_card.dart';
import 'package:tracking_app/features/orders/presentation/order_history/view/widgets/order_details_card.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return Scaffold(body: Center(child: const Text("No order data found").tr()));
    }

    final orderModel = args as OrdersListEntity;

    return Scaffold(
      appBar: AppBar(title: Text("Order details").tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    orderModel.order?.state == "completed"
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: orderModel.order?.state == "completed"
                        ? Colors.green
                        : Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    orderModel.order?.state ?? "un know state".tr(),
                    style: orderModel.order?.state == "completed"
                        ? context.textStyles.medium20.copyWith(
                            color: Colors.green,
                          )
                        : context.textStyles.medium20.copyWith(
                            color: Colors.red,
                          ),
                  ),
                  Spacer(),
                  Text(
                    orderModel.order?.orderNumber ?? "un know number".tr(),
                    style: context.textStyles.semiBold12.copyWith(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(" Pickup address : ", style: context.textStyles.medium20).tr(),
              SizedBox(height: 10),
              AddressCard(
                imagePath: orderModel.store?.image,
                address: orderModel.store?.address ?? "un known address".tr(),
                name: orderModel.store?.name ?? "un known name".tr(),
              ),
              SizedBox(height: 15),
              Text(" User address : ", style: context.textStyles.medium20).tr(),
              SizedBox(height: 10),
              AddressCard(
                imagePath:
                    "https://flower.elevateegy.com/uploads/${orderModel.order?.user?.photo}",
                address:
                    orderModel.order?.shippingAddress?.city ??
                    "un known address".tr(),
                name:
                    "${orderModel.order?.user?.firstName}${orderModel.order?.user?.lastName}",
              ),
              SizedBox(height: 15),
              Text(" Order details : ", style: context.textStyles.medium20).tr(),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {
                  return OrderDetailsCard(
                    name:
                        orderModel.order!.orderItems?[index].id ??
                        "un known name".tr(),
                    quantity:
                        orderModel.order!.orderItems?[index].quantity ?? 0,
                    price: orderModel.order!.orderItems?[index].price ?? 0,
                  );
                },
                itemCount: orderModel.order?.orderItems?.length ?? 0,
              ),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 8,
                    top: 20,
                    bottom: 20,
                    right: 8,
                  ),
                  child: Row(
                    children: [
                      Text("Total : ", style: context.textStyles.medium20).tr(),
                      Spacer(),
                      Text(
                        "${orderModel.order?.totalPrice} EGP",
                        style: context.textStyles.medium20,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    left: 8,
                    top: 20,
                    bottom: 20,
                    right: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Payment method : ",
                        style: context.textStyles.medium20,
                      ).tr(),
                      Spacer(),
                      Text(
                        "${orderModel.order?.paymentType}",
                        style: context.textStyles.medium20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
