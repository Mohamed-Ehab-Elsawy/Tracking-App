import 'package:flutter/material.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class DriverCard extends StatelessWidget {
  final String? firstName;
  final String? email;
  final String? phone;
  final String? photo;
  final String? lastName;
  final VoidCallback? onTap;
  const DriverCard({
    super.key,
    this.firstName,
    this.email,
    this.phone,
    this.photo,
    this.lastName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: context.colors.backgroundColor,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            CustomImageView(
              imagePath: photo ?? "assets/image/splash_android_12.png",
              width: 80,
              height: 80,
              radius: const BorderRadius.all(Radius.circular(40)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${firstName ?? ""} ${lastName ?? ""}",
                    style: context.textStyles.medium20.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    email ?? "",
                    style: context.textStyles.regular16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    phone ?? "",
                    style: context.textStyles.regular16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(onTap: onTap, child: Icon(Icons.arrow_forward_ios)),
          ],
        ),
      ),
    );
  }
}
