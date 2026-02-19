import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_view_model.dart';
import 'package:tracking_app/features/orders/presentation/widgets/address_card.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_details_card.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_events.dart';
import 'package:tracking_app/features/orders/presentation/order_details/view_model/order_details_states.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  late OrderItemNameCubit _cubit;
  late List<String> ids = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      final orderModel = args as OrdersListEntity;

      _cubit = context.read<OrderItemNameCubit>();

      final orderItems = orderModel.order?.orderItems ?? [];

      ids = orderItems.map((e) => e.product?.id).whereType<String>().toList();

      if (ids.isNotEmpty) {
        _cubit.doIntent(GetOrderNamesByIdsEvents(ids: ids));
      }
    }
  }

  Future<void> _refresh() async {
    if (ids.isNotEmpty) {
      await _cubit.doIntent(GetOrderNamesByIdsEvents(ids: ids));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return Scaffold(
        body: Center(child: const Text("No order data found").tr()),
      );
    }

    final orderModel = args as OrdersListEntity;

    return Scaffold(
      appBar: AppBar(title: Text("Order details").tr()),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    const SizedBox(width: 10),
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
                    const Spacer(),
                    Text(
                      orderModel.order?.orderNumber ?? "un know number".tr(),
                      style: context.textStyles.semiBold12.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  " Pickup address : ",
                  style: context.textStyles.medium20,
                ).tr(),
                const SizedBox(height: 10),
                AddressCard(
                  imagePath: orderModel.store?.image,
                  address: orderModel.store?.address ?? "un known address".tr(),
                  name: orderModel.store?.name ?? "un known name".tr(),
                ),
                const SizedBox(height: 15),

                Text(
                  " User address : ",
                  style: context.textStyles.medium20,
                ).tr(),
                const SizedBox(height: 10),
                AddressCard(
                  imagePath:
                      "https://flower.elevateegy.com/uploads/${orderModel.order?.user?.photo}",
                  address:
                      orderModel.order?.shippingAddress?.city ??
                      "un known address".tr(),
                  name:
                      "${orderModel.order?.user?.firstName} ${orderModel.order?.user?.lastName}",
                ),
                const SizedBox(height: 15),

                Text(
                  " Order details : ",
                  style: context.textStyles.medium20,
                ).tr(),
                const SizedBox(height: 20),

                BlocBuilder<OrderItemNameCubit, OrderDetailsStates>(
                  builder: (context, state) {
                    final namesState = state.orderNames;

                    if (namesState?.isLoading ?? false) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final productsMap = namesState?.data ?? {};

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderModel.order?.orderItems?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = orderModel.order!.orderItems![index];

                        final productInfo = productsMap[item.product?.id];

                        return OrderDetailsCard(
                          name: productInfo?.title ?? "un known name".tr(),
                          imagePath:
                              productInfo?.images?[0] ??
                              "assets/images/splash_android_12.png",
                          quantity: item.quantity ?? 0,
                          price: item.price ?? 0,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Total : ",
                          style: context.textStyles.medium20,
                        ).tr(),
                        const Spacer(),
                        Text(
                          "${orderModel.order?.totalPrice} EGP",
                          style: context.textStyles.medium20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 20,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Payment method : ",
                          style: context.textStyles.medium20,
                        ).tr(),
                        const Spacer(),
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
      ),
    );
  }
}
