import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';

class RememberMeCheckBox extends StatefulWidget {
  const RememberMeCheckBox({super.key, required this.isCheck});

  final Function(bool? value) isCheck;

  @override
  State<RememberMeCheckBox> createState() => _RememberMeCheckBoxState();
}

class _RememberMeCheckBoxState extends State<RememberMeCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: isChecked,
        onChanged: (value) => setState(() {
          widget.isCheck(value);
          isChecked = value!;
        }),
      ),
      context.h(AppSpacing.md),
      Text('remember_me'.tr()),
    ],
  );
}
