import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/orders/domain/entity/order_list_entity.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_cubit.dart';
import 'package:tracking_app/features/orders/presentation/orders_history/view_model/order_history_states.dart';
import 'package:tracking_app/features/orders/presentation/widgets/order_card.dart';
import 'package:tracking_app/features/orders/presentation/widgets/orders_number_card.dart';

import '../view_model/order_history_events.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  late OrderHistoryCubit checkoutCubit;
  @override
  void initState() {
    super.initState();
    checkoutCubit = context.read<OrderHistoryCubit>();
    checkoutCubit.doIntent(GetOrdersHistoryEvents());
    checkoutCubit.orderHistoryUiEvent.listen((event) {
      if (event is NavigateToOrderDetails) {
        if (!mounted) return;

        Navigator.pushNamed(
          context,
          AppRoutes.orderDetails,
          arguments: event.order,
        );
      }
    });
  }

  Future<void> _refresh() async {
    await checkoutCubit.doIntent(GetOrdersHistoryEvents());
  }

  @override
  Widget build(BuildContext context) {
    OrderHistoryCubit checkoutCubit = context.read<OrderHistoryCubit>();
    return Scaffold(
      appBar: AppBar(title: Text("Orders").tr()),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: BlocBuilder<OrderHistoryCubit, OrderHistoryStates>(
            builder: (context, state) {
              final orders = state.ordersList;

              if (orders == null ||
                  orders.requestState == RequestState.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (orders.requestState == RequestState.error) {
                return Center(
                  child: Text(
                    orders.errorMessage ?? "something went wrong".tr(),
                  ),
                );
              }

              if (orders.data == null || orders.data!.isEmpty) {
                return Center(child: const Text("No Order Yet").tr());
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OrdersNumberCard(
                          state: "canceled".tr(),
                          number: state.canceledCount,
                        ),

                        OrdersNumberCard(
                          state: "completed".tr(),
                          number: state.completedCount,
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      " Recent orders : ",
                      style: context.textStyles.medium20,
                    ).tr(),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orders.data?.length,
                      itemBuilder: (context, index) {
                        final order = orders.data?[index];
                        return InkWell(
                          onTap: () {
                            checkoutCubit.doEvent(
                              NavigateToOrderDetails(
                                order: order ?? OrdersListEntity(),
                              ),
                            );
                          },
                          child: OrderCard(
                            status: order?.order?.state ?? "",
                            orderNumber:
                                order?.order?.orderNumber ??
                                "un known order number".tr(),
                            shopImagePath: order?.store?.image,
                            shopAddress:
                                order?.store?.address ??
                                "un known address".tr(),
                            shopName:
                                order?.store?.name ?? "un known name".tr(),
                            userImagePath:
                                "https://flower.elevateegy.com/uploads/${order?.order?.user?.photo}",
                            userAddress:
                                order?.order?.shippingAddress?.city ??
                                "un known address".tr(),
                            userName:
                                order?.order?.user?.firstName ??
                                "un known name".tr(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
