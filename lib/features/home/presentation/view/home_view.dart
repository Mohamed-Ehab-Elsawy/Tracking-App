import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/app_error_view.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_events.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_state.dart';
import 'package:tracking_app/features/home/presentation/cubit/orders_view_model.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_card_loading.dart';
import 'package:tracking_app/features/home/presentation/widgets/order_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late OrdersViewModel _ordersViewModel;
  @override
  void initState() {
    super.initState();
    _ordersViewModel = context.read<OrdersViewModel>()
      ..eventStream.listen((event) {
        switch (event) {
          case RejectOrderEvent():
            if (!mounted) return;
            AppSnackBar.show(
              context,
              "orderRejectedSuccessfully".tr(),
              isError: false,
            );

          case AcceptOrderEvent():
            if (!mounted) return;
            AppSnackBar.show(
              context,
              "Order Accepted Successfully",
              isError: false,
            );
          case NavigateToOrderDetailsEvent():
            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/order_details_view',
              (route) => false,
              arguments: event.orderId,
            );
          case ShowSnackBarEvent():
            if (!mounted) return;
            AppSnackBar.show(context, event.message, isError: event.isError);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'floweryRider'.tr(),
          style: GoogleFonts.imFellEnglish(
            fontSize: context.textStyles.regular16
                .copyWith(fontSize: 20)
                .fontSize,
            color: context.theme.colors.primary,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<OrdersViewModel, OrdersState>(
        bloc: _ordersViewModel,
        builder: (context, state) {
          final orders = state.ordersState;
          final hasData = state.orders?.data?.isNotEmpty ?? false;

          if (orders!.isLoading && !hasData) {
            return OrderCardLoading();
          } else if (orders.isError && !hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppErrorView(
                  message: orders.errorMessage ?? '',
                  onRetry: () => _ordersViewModel.doIntent(GetOrdersIntent()),
                ),
              ),
            );
          } else if (hasData || orders.isLoaded) {
            return RefreshIndicator(
              color: context.theme.colors.primary,
              onRefresh: () async =>
                  _ordersViewModel.doIntent(RefreshOrdersIntent()),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    _ordersViewModel.doIntent(LoadMoreOrdersIntent());
                  }
                  return false;
                },
                child: OrderList(state: state),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
