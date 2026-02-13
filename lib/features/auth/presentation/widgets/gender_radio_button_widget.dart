import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';

enum Gender { male, female }

class GenderRadioButtonWidget extends StatelessWidget {
  const GenderRadioButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplyViewModel, ApplyState>(
      builder: (context, state) {
        return Row(
          children: [
            Text("Gender".tr(), style: context.textStyles.medium16),
            Expanded(
              child: RadioGroup<String>(
                groupValue: state.selectedGender ?? '',
                onChanged: (value) {
                  if (value != null) {
                    context.read<ApplyViewModel>().doAction(
                      SelectGender(value),
                    );
                  }
                },

                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,

                        dense: true,
                        toggleable: true,
                        activeColor: context.theme.colors.primary,
                        value: Gender.male.name,
                        title: Text(
                          "male".tr(),
                          style: context.textStyles.regular14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        toggleable: true,
                        visualDensity: VisualDensity.compact,
                        activeColor: context.theme.colors.primary,
                        value: Gender.female.name,

                        title: Text(
                          "female".tr(),
                          style: context.textStyles.regular14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
