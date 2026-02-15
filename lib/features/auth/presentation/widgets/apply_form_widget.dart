import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracking_app/core/extensions/context_theme_extension.dart';
import 'package:tracking_app/core/presentation/feedback/app_snackbar.dart';
import 'package:tracking_app/core/presentation/reusable_widgets/app_error_view.dart';
import 'package:tracking_app/core/route/app_routes.dart';
import 'package:tracking_app/core/validation/form_validator.dart';
import 'package:tracking_app/features/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_intent.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/cubit/apply_view_model.dart';
import 'package:tracking_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:tracking_app/features/auth/presentation/widgets/gender_radio_button_widget.dart';

class ApplyFormWidget extends StatefulWidget {
  const ApplyFormWidget({super.key});

  @override
  State<ApplyFormWidget> createState() => _ApplyFormWidgetState();
}

class _ApplyFormWidgetState extends State<ApplyFormWidget> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _countryController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _vehicleTypeController;
  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _vehicleLicenseController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _idNumberController;
  late final TextEditingController _idImageController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final ApplyViewModel _viewModel;
  File? file;
  String? _selectedVehicleId;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _countryController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehicleNumberController = TextEditingController();
    _vehicleLicenseController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _idNumberController = TextEditingController();
    _idImageController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _viewModel = context.read<ApplyViewModel>();
    _viewModel.navigationStream.listen((event) {
      switch (event) {
        case NavigateSuccessApplyIntent():
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, AppRoutes.applySuccessView);
        case NavigateBackIntent():
          if (!mounted) return;
          Navigator.pop(context);
        case ShowSnackBarEvent():
          if (!mounted) return;
          AppSnackBar.show(context, event.message, isError: event.isError);
      }
    });

    super.initState();
  }

  Future<void> _onPickImage({required bool isID}) async {
    final source = await _showImageSourceBottomSheet(context);
    if (source == null) return;

    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
      maxWidth: 1024,
    );

    if (pickedFile == null) return;
    final file = File(pickedFile.path);

    _viewModel.doIntent(UploadImageIntent(image: file, isNid: isID));
  }

  Future<ImageSource?> _showImageSourceBottomSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.theme.colors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text('gallery'.tr()),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text('camera'.tr()),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 18,
        children: [
          CustomTextFormField(
            hint: 'selectCountry'.tr(),
            label: 'country'.tr(),
            readOnly: true,
            suffixIcon: const Icon(Icons.arrow_drop_down),
            keyboardType: TextInputType.none,
            controller: _countryController,
            validator: (value) => FormValidators.country(value),
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  _countryController.text =
                      "${country.flagEmoji}  ${country.name}";
                },
              );
            },
            onTextChange: (value) {
              _countryController.text = value;
            },
          ),
          CustomTextFormField(
            hint: 'enterFirstName'.tr(),
            label: 'first legal name'.tr(),
            controller: _firstNameController,
            validator: (value) => FormValidators.firstName(value),
            onTextChange: (value) {
              _firstNameController.text = value;
            },
            keyboardType: TextInputType.name,
          ),
          CustomTextFormField(
            hint: 'enterSecondName'.tr(),
            label: 'last legal name'.tr(),
            controller: _lastNameController,
            validator: (value) => FormValidators.lastName(value),
            onTextChange: (value) {
              _lastNameController.text = value;
            },
            keyboardType: TextInputType.name,
          ),
          BlocBuilder<ApplyViewModel, ApplyState>(
            builder: (context, state) {
              return DropdownMenu<String>(
                controller: _vehicleTypeController,
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    context.theme.colors.backgroundColor,
                  ),
                ),
                label: Text("vehicle type".tr()),
                hintText: "selectVehicleType".tr(),

                expandedInsets: EdgeInsets.zero,

                onSelected: (String? value) {
                  _selectedVehicleId = value!;
                  context.read<ApplyViewModel>().doIntent(GetVehiclesIntent());
                },
                dropdownMenuEntries: [
                  if (state.vehicleState!.isLoaded)
                    ...?state.vehicleState?.data?.map((key) {
                      return DropdownMenuEntry<String>(
                        value: key.id,
                        label: key.type,
                      );
                    })
                  else if (state.vehicleState!.isLoading)
                    DropdownMenuEntry<String>(
                      value: 'loading...'.tr(),
                      label: 'loading...'.tr(),
                    )
                  else if (state.vehicleState!.isError)
                    DropdownMenuEntry<String>(
                      value: state.vehicleState!.errorMessage.toString(),
                      label: state.vehicleState!.errorMessage.toString(),
                      labelWidget: AppErrorView(
                        message: state.vehicleState!.errorMessage.toString(),
                        onRetry: () {
                          context.read<ApplyViewModel>().doIntent(
                            GetVehiclesIntent(),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
          CustomTextFormField(
            hint: 'enterVehicleNumber'.tr(),
            label: 'vehicleNumber'.tr(),
            controller: _vehicleNumberController,

            validator: (value) => FormValidators.vehicleNumber(value),
            onTextChange: (value) {
              _vehicleNumberController.text = value;
            },
            keyboardType: TextInputType.number,
          ),
          BlocListener<ApplyViewModel, ApplyState>(
            listener: (context, state) {
              if (state.vehicleLicense != null) {
                _vehicleLicenseController.text = state.vehicleLicense!.path
                    .split('/')
                    .last;
              }
            },
            child: CustomTextFormField(
              hint: 'uploadLicense'.tr(),
              label: 'vehicleLicense'.tr(),
              controller: _vehicleLicenseController,
              suffixIcon: const Icon(Icons.file_upload_outlined),
              readOnly: true,
              keyboardType: TextInputType.none,
              onTap: () {
                _onPickImage(isID: false);
              },
              validator: (value) => FormValidators.vehicleLicense(value),
              onTextChange: (value) {
                _vehicleLicenseController.text = value;
              },
            ),
          ),
          CustomTextFormField(
            hint: 'enterEmail'.tr(),
            label: 'email'.tr(),
            controller: _emailController,
            validator: (value) => FormValidators.email(value),
            onTextChange: (value) {
              _emailController.text = value;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          CustomTextFormField(
            hint: 'enterPhone'.tr(),
            label: 'phone'.tr(),
            controller: _phoneController,
            validator: (value) => FormValidators.phoneNumber(value),
            onTextChange: (value) {
              _phoneController.text = value;
            },
            keyboardType: TextInputType.phone,
          ),
          CustomTextFormField(
            hint: 'enterID'.tr(),
            label: 'id number'.tr(),
            controller: _idNumberController,
            validator: (value) => FormValidators.nid(value),
            onTextChange: (value) {
              _idNumberController.text = value;
            },
            keyboardType: TextInputType.number,
          ),
          BlocListener<ApplyViewModel, ApplyState>(
            listener: (context, state) {
              if (state.nidImage != null) {
                _idImageController.text = state.nidImage!.path.split('/').last;
              }
            },
            child: CustomTextFormField(
              hint: 'uploadID'.tr(),
              label: 'id image'.tr(),
              controller: _idImageController,
              suffixIcon: const Icon(Icons.file_upload_outlined),
              readOnly: true,
              keyboardType: TextInputType.none,
              onTap: () {
                _onPickImage(isID: true);
              },
              validator: (value) => FormValidators.idImage(value),
              onTextChange: (value) {
                _idImageController.text = value;
              },
            ),
          ),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: CustomTextFormField(
                  hint: 'enterPassword'.tr(),
                  label: 'password'.tr(),
                  controller: _passwordController,
                  validator: (value) => FormValidators.password(value),
                  onTextChange: (value) {
                    _passwordController.text = value;
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  hint: 'confirmPassword'.tr(),
                  label: 'confirmPassword'.tr(),
                  controller: _confirmPasswordController,
                  validator: (value) => FormValidators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                  onTextChange: (value) {
                    _confirmPasswordController.text = value;
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
            ],
          ),
          GenderRadioButtonWidget(),
          BlocConsumer<ApplyViewModel, ApplyState>(
            listener: (context, state) {
              if (state.applyState.isError) {
                return _viewModel.doNavigationAction(
                  ShowSnackBarEvent(
                    message: state.applyState.errorMessage.toString(),
                    isError: true,
                  ),
                );
              } else if (state.applyState.isLoaded) {
                _viewModel.doNavigationAction(
                  ShowSnackBarEvent(
                    message: state.applyState.data!.message ?? 'success'.tr(),
                    isError: false,
                  ),
                );
                _viewModel.doNavigationAction(NavigateSuccessApplyIntent());
              }
            },
            builder: (context, state) => ElevatedButton(
              onPressed: () {
                state.applyState.isLoading ? null : validateSignUP();
              },
              child: state.applyState.isLoading
                  ? CircularProgressIndicator(
                      color: context.theme.colors.backgroundColor,
                    )
                  : Text('continue'.tr()),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  void validateSignUP() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final currentState = _viewModel.state;

    if (_vehicleTypeController.text.isEmpty) {
      _viewModel.doNavigationAction(
        ShowSnackBarEvent(message: 'selectVehicleType'.tr(), isError: true),
      );
      return;
    }

    final vehicleData = currentState.vehicleState?.data;

    if (vehicleData == null || vehicleData.isEmpty) return;

    final selectedVehicle = vehicleData.firstWhere(
      (v) => v.id == _selectedVehicleId,
    );

    DriverEntity driverEntity = DriverEntity(
      country: _countryController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      vehicleType: selectedVehicle,
      vehicleLicense: currentState.vehicleLicense!,
      vehicleNumber: _vehicleNumberController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      nid: _idNumberController.text.trim(),
      nidImage: currentState.nidImage!,
      password: _passwordController.text.trim(),
      rePassword: _confirmPasswordController.text.trim(),
      gender: currentState.selectedGender,
    );

    _viewModel.doIntent(SubmitApplyIntent(driverEntity: driverEntity));
  }
}
