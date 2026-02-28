import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/widgets/apply_form_widget.dart';

class ApplyView extends StatelessWidget {
  const ApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('apply'.tr()),

        leading: IconButton(
          onPressed: () {
            context.read<ApplyViewModel>().emitEvent(NavigateBackIntent());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("welcome".tr(), style: context.textStyles.medium20),
              Text(
                "you want to be a delivery man?".tr(),
                style: context.textStyles.medium16,
              ),
              Text("join our team".tr(), style: context.textStyles.medium16),
              const SizedBox(height: 18),
              ApplyFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
