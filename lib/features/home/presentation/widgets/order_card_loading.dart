import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_card.dart';

class OrderCardLoading extends StatelessWidget {
  const OrderCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) => OrderCard(order: null),
      ),
    );
  }
}
