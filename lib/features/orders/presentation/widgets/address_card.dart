import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class AddressCard extends StatelessWidget {
  final String? imagePath;
  final String? address;
  final String? name;
  const AddressCard({
    super.key,
    required this.imagePath,
    required this.address,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Row(
          children: [
            CustomImageView(
              width: 70,
              height: 70,
              radius: const BorderRadius.all(Radius.circular(40)),
              imagePath: imagePath ?? "assets/images/Flowery logo.png",
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "unknown name".tr(),
                  style: context.textStyles.regular14.copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.location_on),
                    Text(
                      address ?? "unknown address".tr(),
                      style: context.textStyles.regular14.copyWith(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
