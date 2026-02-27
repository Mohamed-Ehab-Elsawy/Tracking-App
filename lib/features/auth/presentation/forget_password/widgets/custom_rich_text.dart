import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    this.onTap,
    required this.underLineText,
    required this.baseText,
  });
  final String underLineText;
  final String baseText;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    var textStyle = context.textStyles;
    var color = context.colors;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: baseText, style: textStyle.regular16),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onTap,
            text: underLineText,
            style: textStyle.regular16.copyWith(
              color: color.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
