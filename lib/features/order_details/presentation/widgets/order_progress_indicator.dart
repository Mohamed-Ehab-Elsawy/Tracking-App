import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';

class OrderProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OrderProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: index <= currentStep ? colors.success : colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
