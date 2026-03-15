import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/theme/dimensions/app_insets.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_details_card.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_status_card.dart';

import 'widgets/order_progress_indicator.dart';

class CurrentOrderDetailsView extends StatelessWidget {
  const CurrentOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("order_details".tr()),
      scrolledUnderElevation: 0,
    ),
    body: Padding(
      padding: AppInsets.screen,
      child: BlocBuilder<CurrentOrderDetailsCubit, CurrentOrderDetailsState>(
        builder: (context, state) {
          final cubit = context.read<CurrentOrderDetailsCubit>();
          final baseState = state.currentState;

          if (baseState.isLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const CurrentOrderProgressIndicator(
                    currentStep: 0,
                    totalSteps: 5,
                  ),

                  context.h(AppSpacing.md),

                  const _FakeStatusCard(),

                  context.h(AppSpacing.md),

                  const _FakeDetailsCard(),
                  context.h(AppSpacing.md),
                  const _FakeDetailsCard(),
                  context.h(AppSpacing.md),

                  const _FakeDetailsCard(),
                  const _FakeDetailsCard(),
                  const _FakeDetailsCard(),
                ],
              ),
            );
          }

          if (baseState.isError) {
            return Center(child: Text(baseState.errorMessage ?? ""));
          }

          if (baseState.isLoaded && baseState.data != null) {
            final entity = baseState.data!;

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                CurrentOrderProgressIndicator(
                  currentStep: cubit.state.currentStep,
                  totalSteps: 5,
                ),

                context.h(AppSpacing.md),

                CurrentOrderStatusCard(entity: entity),

                context.h(AppSpacing.md),

                Text("pickup_address".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                CurrentOrderDetailsCard(
                  title: entity.storeName,
                  description: entity.storeAddress,
                  phoneNumber: entity.storePhone,
                ),

                context.h(AppSpacing.md),

                Text("user_address".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                CurrentOrderDetailsCard(
                  title: entity.userName,
                  description: entity.userAddress,
                  phoneNumber: entity.userAddress,
                ),

                context.h(AppSpacing.md),

                Text("order_details".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                ...entity.details.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: CurrentOrderDetailsCard(
                      title: item.title,
                      description: "egp".tr() + item.price,
                      count: item.count.toString(),
                    ),
                  ),
                ),

                context.h(AppSpacing.md),

                ElevatedButton(
                  onPressed: () async {
                    cubit.doIntent(ChangeStepIntent());
                    cubit.doIntent(
                      SendOrderStatusNotificationIntent(
                        token: state.currentState.data!.userToken,
                        status: state.currentState.data?.status ?? "",
                      ),
                    );
                  },
                  child: baseState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Next Step"),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

class _FakeStatusCard extends StatelessWidget {
  const _FakeStatusCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Status : Accepted"),
            SizedBox(height: 8),
            Text("Order ID : #123456"),
            SizedBox(height: 8),
            Text("Wed, 03 sep 2024, 11:00 AM"),
          ],
        ),
      ),
    );
  }
}

class _FakeDetailsCard extends StatelessWidget {
  const _FakeDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(radius: 25),
        title: const Text("Store Name"),
        subtitle: const Text("Store Address Here"),
        trailing: const Icon(Icons.phone),
      ),
    );
  }
}
