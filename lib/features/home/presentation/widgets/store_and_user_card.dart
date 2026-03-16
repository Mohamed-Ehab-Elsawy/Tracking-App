import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracking_app/core/constants/asset_constants.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';

class StoreAndUserCard extends StatelessWidget {
  const StoreAndUserCard({
    super.key,
    required this.image,
    required this.name,
    this.address,
  });

  final String? image;
  final String? name;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colors.secondary,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomImageView(
              radius: BorderRadius.circular(44),
              fit: BoxFit.cover,
              height: 44,
              width: 44,
              imagePath: image,
              placeHolder: AssetConstants.placeholderImage,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name ?? 'noNameProvided'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.regular14.copyWith(
                      fontWeight: FontWeight.w300,
                      color: context.theme.colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 15),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          address ?? 'noAddressProvided'.tr(),
                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
