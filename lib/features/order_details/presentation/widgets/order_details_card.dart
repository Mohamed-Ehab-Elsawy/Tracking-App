import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/extensions/context_spacing_extension.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/dimensions/app_spacing.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_contract.dart';
import 'package:tracking_app/features/order_details/presentation/managers/order_details_cubit.dart';

class CurrentOrderDetailsCard extends StatelessWidget {
  final String title, description;
  final String? phoneNumber, count;

  const CurrentOrderDetailsCard({
    super.key,
    required this.title,
    required this.description,
    this.phoneNumber,
    this.count,
  });

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    child: ListTile(
      leading: CustomImageView(
        imagePath: "assets/images/placeholder.png",
        height: 50,
        width: 50,
        radius: BorderRadius.all(Radius.circular(50)),
      ),
      title: Text(
        title,
        style: context.textStyles.regular14.copyWith(
          color: context.colors.grey,
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (phoneNumber != null)
            CustomImageView(
              imagePath: "assets/icons/location_icon.svg",
              width: 16,
              height: 16,
            ),
          if (phoneNumber != null) context.w(AppSpacing.xs),
          Expanded(
            child: Text(
              description,
              maxLines: 1,
              style: context.textStyles.regular16.copyWith(
                color: context.colors.surface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.only(
        left: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      trailing: phoneNumber != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      context.read<CurrentOrderDetailsCubit>().doIntent(
                    PhoneCallPressedIntent(phoneNumber!),
                  ),
                  icon: Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: context.colors.primary,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () =>
                      context.read<CurrentOrderDetailsCubit>().doIntent(
                    WhatsAppPressedIntent(phoneNumber!),
                  ),
                  icon: CustomImageView(
                    imagePath: "assets/icons/whatsapp_icon.svg",
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            )
          : count != null
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'X $count',
                style: context.textStyles.medium16.copyWith(
                  color: context.colors.primary,
                ),
              ),
            )
          : SizedBox.shrink(),
    ),
  );
}
