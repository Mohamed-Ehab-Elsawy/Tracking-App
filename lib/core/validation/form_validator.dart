class FormValidators {
  static const _userNamePattern = r'^[\p{L}\p{N}_]+$';
  static const _namePattern = r'^[\p{L}\s]+$';
  static const _emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  static String? username(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterUsername';
    if (v.length < 3) return 'validation.least3CharUsername';
    if (!RegExp(_userNamePattern, unicode: true).hasMatch(v)) {
      return 'validation.usernamePattern';
    }
    return null;
  }

  static String? firstName(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterFirstName';
    if (v.length < 2) return 'validation.least2CharFirstName';
    if (!RegExp(_namePattern, unicode: true).hasMatch(v)) {
      return 'validation.firstNamePattern';
    }
    return null;
  }

  static String? lastName(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterLastName';
    if (v.length < 2) return 'validation.least2CharLastName';
    if (!RegExp(_namePattern, unicode: true).hasMatch(v)) {
      return 'validation.lastNamePattern';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterEmail';
    if (!RegExp(_emailPattern).hasMatch(v)) return 'validation.validEmail';
    return null;
  }

  static String? password(String? value) {
    final v = value?.trim();
    if (v == null || v.isEmpty) return 'validation.enterPassword';
    if (v.length < 8) return 'validation.passwordCriteria';

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(v);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);
    final hasSpecial = RegExp(r'[@$!%*?&]').hasMatch(v);

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecial) {
      return 'validation.passwordValidation';
    }

    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'validation.enterConfirmPassword';
    }
    if (value != originalPassword) return 'validation.confirmPasswordNotMatch';
    return null;
  }

  static String? phoneNumber(String? value) {
    final v = value?.replaceAll(RegExp(r'\s+'), '');
    if (v == null || v.isEmpty) return 'validation.enterPhoneNumber';
    if (!RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(v)) {
      return 'validation.validPhoneNumber';
    }
    return null;
  }

  static String? recipientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.enterRecipientName';
    }
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) return 'validation.enterAddress';
    return null;
  }
}
