import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tracking_app/core/constants/app_constants.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/local/app_local_storage.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/services/event_bus_service.dart';
import 'package:tracking_app/core/theme/dimensions/app_insets.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_details_card.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_status_card.dart';

import 'widgets/order_progress_indicator.dart';

class CurrentOrderDetailsView extends StatefulWidget {
  const CurrentOrderDetailsView({super.key});

  @override
  State<CurrentOrderDetailsView> createState() =>
      _CurrentOrderDetailsViewState();
}

class _CurrentOrderDetailsViewState extends State<CurrentOrderDetailsView> {
  @override
  void didChangeDependencies() {
    EventBusService.eventBus.on<SilentNotificationEvent>().listen((event) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.orderDeliverySuccessView,
        (route) => false,
      );
      AppLocalStorage.removeData(AppConstants.orderId);
    });
    super.didChangeDependencies();
  }

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
            final String currentStatus = switch (state.currentStep) {
              0 => "accepted",
              1 => "picked",
              2 => "out_for_delivery",
              3 => "arrived",
              4 => "delivered",
              int() => 'awaiting',
            };
            final String buttonText = switch (state.currentStep) {
              0 => "arrived_at_pickup_point",
              1 => "start_deliver",
              2 => "arrived_to_the_customer",
              3 => "delivered_to_the_customer",
              int() => "awaiting",
            };
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                CurrentOrderProgressIndicator(
                  currentStep: cubit.state.currentStep,
                  totalSteps: 5,
                ),

                context.h(AppSpacing.md),

                CurrentOrderStatusCard(
                  entity: entity,
                  currentState: currentStatus,
                ),

                context.h(AppSpacing.md),

                Text("pickup_address".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                CurrentOrderDetailsCard(
                  title: entity.storeName ?? "",
                  description: entity.storeAddress ?? "",
                  phoneNumber: entity.userPhoneNumber,
                  image: entity.storeImage,
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.mapOrderView,
                    arguments: {'isUser': false, 'order': entity},
                  ),
                ),

                context.h(AppSpacing.md),

                Text("user_address".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                CurrentOrderDetailsCard(
                  title: entity.userName ?? "",
                  description: entity.userAddress ?? "",
                  image: entity.userImage,
                  phoneNumber: entity.userPhoneNumber,
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.mapOrderView,
                    arguments: {'isUser': true, 'order': entity},
                  ),
                ),

                context.h(AppSpacing.md),

                Text("order_details".tr(), style: context.textStyles.medium20),
                context.h(AppSpacing.sm),

                ...(entity.details ?? []).map(
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
                  onPressed: buttonText != 'awaiting'
                      ? () {
                          cubit.doIntent(
                            ChangeStepIntent(
                              token: state.currentState.data?.userToken ?? "",
                              status: state.currentState.data?.status ?? "",
                            ),
                          );
                        }
                      : null,
                  child: Text(buttonText.tr()),
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
