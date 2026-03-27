import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/features/home/data/models/active_order_dto.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_state.dart';
import 'package:tracking_app/features/order_details/presentation/managers/map_order_view_model.dart';
import 'package:tracking_app/features/order_details/presentation/widgets/order_details_card.dart';

class BottomSheetContainer extends StatefulWidget {
  const BottomSheetContainer({
    super.key,
    required this.order,
    required this.firstStore,
  });

  final ActiveOrderDto order;
  final bool firstStore;

  @override
  State<StatefulWidget> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentGeometry.center,
            child: SizedBox(
              width: 65,
              child: Divider(
                height: 4,
                thickness: 4,
                color: Colors.red,
                radius: BorderRadius.circular(10),
              ),
            ),
          ),
          context.h(24),

          context.h(8),
          if (!widget.firstStore) ...[
            Text("pickup_address".tr()),
            _store(),
            context.h(24),
            Text("user_address".tr()),
            context.h(8),
            _user(),
          ] else ...[
            Text("user_address".tr()),
            _user(),
            context.h(24),
            Text("pickup_address".tr()),
            context.h(8),
            _store(),
          ],
        ],
      ),
    ),
  );

  _store() => CurrentOrderDetailsCard(
    title: widget.order.storeName!,
    description: widget.order.storeAddress!,
    phoneNumber: widget.order.storePhoneNumber,
    image: widget.order.storeImage,
    onTapPhoneCall: () => context.read<MapOrderViewModel>().doIntent(
      PhoneCallPressedIntent(phoneNumber: widget.order.storePhoneNumber ?? ""),
    ),
    onTapWhatsappChat: () => context.read<MapOrderViewModel>().doIntent(
      WhatsAppPressedIntent(phoneNumber: widget.order.storePhoneNumber ?? ""),
    ),
  );

  _user() => CurrentOrderDetailsCard(
    title: widget.order.userName ?? "",
    description: widget.order.userAddress ?? "",
    phoneNumber: widget.order.phone,

    image: widget.order.userImage,
        onTapPhoneCall: () =>
            context.read<MapOrderViewModel>().doIntent(
              PhoneCallPressedIntent(phoneNumber: widget.order.phone ?? ""),
            ),
        onTapWhatsappChat: () =>
            context.read<MapOrderViewModel>().doIntent(
              WhatsAppPressedIntent(phoneNumber: widget.order.phone ?? ""),
            ),
      );
}
