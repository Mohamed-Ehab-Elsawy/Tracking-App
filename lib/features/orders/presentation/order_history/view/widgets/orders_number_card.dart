import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class OrdersNumberCard extends StatelessWidget {
  OrdersNumberCard({super.key, required this.state, required this.number});
  String? state;
  int? number;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: context.colors.lightPink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$number", style: context.textStyles.medium20),
            Row(
              children: [
                Icon(
                  state == "completed"
                      ? Icons.check_circle_outline
                      : Icons.cancel_outlined,
                  color: state == "completed" ? Colors.green : Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  state ?? "un know state",
                  style: state == "completed"
                      ? context.textStyles.medium20.copyWith(
                          color: Colors.green,
                        )
                      : context.textStyles.medium20.copyWith(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
