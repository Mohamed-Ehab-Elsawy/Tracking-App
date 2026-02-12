import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/theme/typography/typography_extension.dart';
import 'package:tracking_app/features/localization/model/app_language.dart';
import 'package:tracking_app/features/localization/view/language_bottom_sheet.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/vehicle_info_card.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/driver_card.dart';
import 'package:tracking_app/features/profile/presentation/profile_view/widget/main_profile_item.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_events.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_states.dart';
import 'package:tracking_app/features/profile/presentation/profile_view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

final profileViewModel = getIt.get<ProfileViewModel>();

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    final profileViewModel = context.read<ProfileViewModel>();
    super.initState();
    profileViewModel.uiEvents.listen((event) {
      switch (event) {
        case GetDriverDataEvent():
          {
            if (!mounted) return;
            //
          }
        case OnLanguageClickIntent():
          {
            if (!mounted) return;
            showLanguageBottomSheet();
          }
        case OnLogoutClickIntent():
          {
            if (!mounted) return;
            //
          }

        case OnProfileClickIntent():
          {
            if (!mounted) return;
            Navigator.pushNamed(
              context,
              '/update_driver_view',
              arguments: profileViewModel.state.driverData?.data,
            ).then((_) {
              context.read<ProfileViewModel>().doIntent(GetDriverDataEvent());
            });
          }
        case OnVehicleInfoClickIntent():
          {
            if (!mounted) return;
            //
          }
        case NavigateToNotification():
          {
            if (!mounted) return;
            //
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLanguage currentLanguage = AppLanguage.values.firstWhere(
      (lang) => lang.locale.languageCode == (context.locale.languageCode),
      orElse: () => AppLanguage.english,
    );
    final profileViewModel = context.read<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: context.textStyles.medium20).tr(),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(Icons.notifications_none_sharp),
            ),
            onTap: () => profileViewModel.doEvent(NavigateToNotification()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            BlocBuilder<ProfileViewModel, ProfileStates>(
              bloc: profileViewModel,
              builder: (context, state) {
                if (state.driverData?.requestState == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.driverData?.requestState ==
                    RequestState.error) {
                  return Text(
                    state.driverData?.errorMessage ??
                        "something went wrong".tr(),
                  );
                } else {
                  var state = profileViewModel.state.driverData?.data;
                  return Column(
                    children: [
                      DriverCard(
                        firstName: state?.firstName,
                        email: state?.email,
                        phone: state?.phone,
                        photo: state?.photo,
                        lastName: state?.lastName,
                        onTap: () =>
                            profileViewModel.doEvent(OnProfileClickIntent()),
                      ),
                      SizedBox(height: 20),
                      VehicleInfoCard(
                        vehicleType: state?.vehicleType,
                        vehicleNumber: state?.vehicleNumber,
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              },
            ),
            MainProfileItem(
              prefix: const Icon(Icons.translate_rounded, size: 18),
              title: 'language'.tr(),
              suffix: TextButton(
                style: TextButton.styleFrom(),
                onPressed: () =>
                    profileViewModel.doEvent(OnLanguageClickIntent()),
                child: Text(
                  currentLanguage.displayName.tr(),
                  style: context.textStyles.regular12.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
              onTap: () => profileViewModel.doEvent(OnLanguageClickIntent()),
            ),
            MainProfileItem(
              title: 'logout'.tr(),
              onTap: () => profileViewModel.doEvent(OnLogoutClickIntent()),
              prefix: const Icon(Icons.logout, size: 16),
              suffix: const Icon(Icons.logout, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: const Color(0xFFF9F9F9),
      //isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      showDragHandle: true,
      builder: (context) => Container(
        //   height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: context.colors.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const LanguageBottomSheet(),
      ),
    );
  }
}
