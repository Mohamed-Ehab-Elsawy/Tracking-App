import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_card.dart';

class OrderList extends StatelessWidget {
  const OrderList({super.key, required this.state});
  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.orders!.data!.length + (state.hasMore == true ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.orders!.data!.length) {
          return OrderCard(order: state.orders!.data![index]);
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(
                color: context.theme.colors.primary,
              ),
            ),
          );
        }
      },
    );
  }
}
