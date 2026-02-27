import 'package:easy_localization/easy_localization.dart';

class FormValidators {
  static const _userNamePattern = r'^[\p{L}\p{N}_]+$';
  static const _namePattern = r'^[\p{L}\s]+$';
  static const _emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  static String? username(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterUsername'.tr();
    if (v.length < 3) return 'validation.least3CharUsername'.tr();
    if (!RegExp(_userNamePattern, unicode: true).hasMatch(v)) {
      return 'validation.usernamePattern'.tr();
    }
    return null;
  }

  static String? firstName(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterFirstName'.tr();
    if (v.length < 2) return 'validation.least2CharFirstName'.tr();
    if (!RegExp(_namePattern, unicode: true).hasMatch(v)) {
      return 'validation.firstNamePattern'.tr();
    }
    return null;
  }

  static String? lastName(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterLastName'.tr();
    if (v.length < 2) return 'validation.least2CharLastName'.tr();
    if (!RegExp(_namePattern, unicode: true).hasMatch(v)) {
      return 'validation.lastNamePattern'.tr();
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterEmail'.tr();
    if (!RegExp(_emailPattern).hasMatch(v)) return 'validation.validEmail'.tr();
    return null;
  }

  static String? password(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterPassword'.tr();
    if (v.length < 8) return 'validation.passwordCriteria'.tr();

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(v);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);
    final hasSpecial = RegExp(r'[@$!%*?&]').hasMatch(v);

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecial) {
      return 'validation.passwordValidation'.tr();
    }

    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'validation.enterConfirmPassword'.tr();
    }
    if (value != originalPassword) {
      return 'validation.confirmPasswordNotMatch'.tr();
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    final v = value?.replaceAll(RegExp(r'\s+'), '');
    if (v == null || v.isEmpty) return 'validation.enterPhoneNumber'.tr();
    if (!RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(v)) {
      return 'validation.validPhoneNumber'.tr();
    }
    return null;
  }

  static String? recipientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.enterRecipientName'.tr();
    }
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.enterAddress'.tr();
    }
    return null;
  }

  static String? country(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.enterCountry'.tr();
    }
    return null;
  }

  static String? vehicleType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.selectVehicleType'.tr();
    }
    return null;
  }

  static String? vehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.enterVehicleNumber'.tr();
    }
    return null;
  }

  static String? nid(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterNID'.tr();
    if (v.length < 10) return 'validation.validNID'.tr();
    return null;
  }

  static String? gender(String? value) {
    if (value == null || value.isEmpty) return 'validation.selectGender'.tr();
    return null;
  }

  static String? vehicleLicense(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.uploadLicense'.tr();
    }
    return null;
  }

  static String? idImage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.uploadID'.tr();
    }
    return null;
  }
}
