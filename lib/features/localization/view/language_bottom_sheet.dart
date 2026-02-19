import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/localization/model/app_language.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Change Language".tr(),
              style: context.textStyles.semiBold24.copyWith(
                color: context.colors.primary[50],
              ),
            ),
            const SizedBox(height: 20),

            RadioGroup<AppLanguage>(
              groupValue: getCurrentLanguage(context),
              onChanged: (AppLanguage? newValue) {
                if (newValue == null) return;
                context.setLocale(newValue.locale);
                Navigator.pop(context);
              },
              child: Column(
                children: AppLanguage.values.map((language) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: RadioListTile<AppLanguage>(
                      value: language,
                      title: Text(
                        language.displayName.tr(),
                        style: context.textStyles.medium16.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      activeColor: context.colors.primary,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppLanguage getCurrentLanguage(BuildContext context) {
    final locale = context.locale;

    return AppLanguage.values.firstWhere(
      (lang) => lang.locale.languageCode == locale.languageCode,
      orElse: () => AppLanguage.english,
    );
  }
}
