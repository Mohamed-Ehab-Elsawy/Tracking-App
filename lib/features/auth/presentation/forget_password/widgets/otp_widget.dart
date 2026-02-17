import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPWidget extends StatelessWidget {
  const OTPWidget({
    super.key,
    required this.hasError,
    required this.isLoading,
    required this.onCompleted,
  });

  final bool hasError;
  final bool isLoading;
  final void Function(String)? onCompleted;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      defaultPinTheme: PinTheme(
        height: 50,
        width: 68,
        decoration: BoxDecoration(
          border: Border.all(
            color: hasError ? Colors.red : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      closeKeyboardWhenCompleted: true,
      showCursor: true,
      onTapUpOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      focusedPinTheme: PinTheme(
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        height: 50,
        width: 68,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      submittedPinTheme: PinTheme(
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        height: 50,
        width: 68,
        decoration: BoxDecoration(
          border: Border.all(
            color: hasError ? Colors.red : Theme.of(context).primaryColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onCompleted: isLoading ? null : onCompleted,
      keyboardType: TextInputType.number,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}
