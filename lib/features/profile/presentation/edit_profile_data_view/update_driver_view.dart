import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/bloc/base_state.dart';
import 'package:tracking_app/core/di/di.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/custom_image_view.dart';
import 'package:tracking_app/core/theme/colors/color_extension.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/features/profile/data/model/request/update_profile_request.dart';
import 'package:tracking_app/features/profile/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_events.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_states.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile_data_view_model/update_profile_view_model.dart';

class UpdateDriverView extends StatefulWidget {
  const UpdateDriverView({super.key});

  @override
  State<UpdateDriverView> createState() => _UpdateDriverViewState();
}

class _UpdateDriverViewState extends State<UpdateDriverView> {
  late DriverEntity driverEntity;

  final _formKey = GlobalKey<FormState>();
  final updateProfileViewModel = getIt<UpdateProfileViewModel>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late String _originalFirstName;
  late String _originalLastName;
  late String _originalEmail;
  late String _originalPhone;

  bool _isDataChanged = false;

  @override
  void initState() {
    super.initState();

    void checkChanges() {
      final changed =
          firstNameController.text.trim() != _originalFirstName ||
          lastNameController.text.trim() != _originalLastName ||
          emailController.text.trim() != _originalEmail ||
          phoneController.text.trim() != _originalPhone;

      if (changed != _isDataChanged) {
        setState(() => _isDataChanged = changed);
      }
    }

    firstNameController.addListener(checkChanges);
    lastNameController.addListener(checkChanges);
    emailController.addListener(checkChanges);
    phoneController.addListener(checkChanges);

    updateProfileViewModel.uiEvents.listen((event) {
      switch (event) {
        case NavigateToResetPassword():
          {
            if (!mounted) return;
            //
          }
        case ShowToast():
          {
            if (!mounted) return;
            AppSnackBar.show(context, event.message, isError: event.isError);
          }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    driverEntity = args is DriverEntity ? args : DriverEntity();

    _fillForm(driverEntity);

    _originalFirstName = driverEntity.firstName ?? '';
    _originalLastName = driverEntity.lastName ?? '';
    _originalEmail = driverEntity.email ?? '';
    _originalPhone = driverEntity.phone ?? '';
  }

  void _fillForm(DriverEntity user) {
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileViewModel, UpdateProfileStates>(
      bloc: updateProfileViewModel,
      listenWhen: (previous, current) {
        return previous.ubdateDriverData?.requestState !=
            current.ubdateDriverData?.requestState;
      },
      listener: (context, state) {
        final updateState = state.ubdateDriverData;

        if (updateState == null) return;

        if (updateState.requestState == RequestState.loaded &&
            updateState.data != null) {
          updateProfileViewModel.doEvent(
            ShowToast(message: "Profile updated successfully", isError: false),
          );
          setState(() {
            _originalFirstName = firstNameController.text.trim();
            _originalLastName = lastNameController.text.trim();
            _originalEmail = emailController.text.trim();
            _originalPhone = phoneController.text.trim();
            _isDataChanged = false;
          });
          driverEntity = updateState.data!;
        } else if (updateState.requestState == RequestState.error &&
            updateState.errorMessage != null) {
          updateProfileViewModel.doEvent(
            ShowToast(message: updateState.errorMessage!, isError: true),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(title: Text("Edit profile".tr())),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CustomImageView(
                  imagePath:
                      driverEntity.photo ??
                      "assets/image/splash_android_12.png",
                  width: 80,
                  height: 80,
                  radius: const BorderRadius.all(Radius.circular(40)),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: "First name".tr(),
                        ),
                        validator: FormValidators.firstName,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: "Last name".tr(),
                        ),
                        validator: FormValidators.lastName,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email".tr()),
                  validator: FormValidators.email,
                ),

                const SizedBox(height: 18),

                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone number".tr()),
                  validator: FormValidators.phoneNumber,
                ),

                const SizedBox(height: 18),

                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Password".tr(),
                    hintText: "*******",
                    suffixIcon: TextButton(
                      onPressed: () {
                        /// navigate to reset password
                      },
                      child: Text("Change".tr()),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                BlocBuilder<UpdateProfileViewModel, UpdateProfileStates>(
                  bloc: updateProfileViewModel,
                  builder: (context, state) {
                    final isLoading =
                        state.ubdateDriverData?.isLoading ?? false;
                    return ElevatedButton(
                      onPressed: (!_isDataChanged || isLoading)
                          ? null
                          : _onUpdate,
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: context.colors.secondary,
                            )
                          : Text("update".tr()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;

    final request = UpdateProfileRequest(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    updateProfileViewModel.doIntent(UpdateDataEvent(request));
  }
}
