import 'package:retina_scan_app/res/constants/app_strings.dart';

/// Reusable form validators. Each one returns `null` when the value is valid,
/// or an error message that the field shows under itself.
///
/// Usage: `validator: Validators.email`
class Validators {
  Validators._();

  /// Basic email format: something@something.domain
  static final RegExp _emailRegex = RegExp(
    r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$',
  );

  /// Optional "+" followed by 10 to 15 digits.
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

  static final RegExp _hasLetter = RegExp(r'[A-Za-z]');
  static final RegExp _hasDigit = RegExp(r'\d');

  static const int _minPasswordLength = 8;
  static const int _minNameLength = 3;
  static const int _minSymptomsLength = 10;
  static const int _minAge = 1;
  static const int _maxAge = 120;

  /// Generic "must not be empty" check with a custom message.
  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Full name: required and at least [_minNameLength] characters.
  static String? fullName(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.errNameRequired;
    if (text.length < _minNameLength) return AppStrings.errNameShort;
    return null;
  }

  /// Email: required and must look like a real address.
  static String? email(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.errEmailRequired;
    if (!_emailRegex.hasMatch(text)) return AppStrings.errEmailInvalid;
    return null;
  }

  /// Password on the login screen: only checks that something is entered.
  static String? requiredPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.errPasswordRequired;
    return null;
  }

  /// Password on the sign up screen: min length, one letter and one digit.
  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.errPasswordRequired;
    if (value.length < _minPasswordLength) return AppStrings.errPasswordShort;
    if (!_hasLetter.hasMatch(value) || !_hasDigit.hasMatch(value)) {
      return AppStrings.errPasswordWeak;
    }
    return null;
  }

  /// Confirm password: required and must match [original].
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return AppStrings.errConfirmRequired;
    if (value != original) return AppStrings.errPasswordMismatch;
    return null;
  }

  /// Phone number: spaces and dashes are ignored.
  static String? phone(String? value) {
    final String text = (value ?? '').replaceAll(RegExp(r'[\s\-]'), '');
    if (text.isEmpty) return AppStrings.errPhoneRequired;
    if (!_phoneRegex.hasMatch(text)) return AppStrings.errPhoneInvalid;
    return null;
  }

  /// Age: a whole number between 1 and 120.
  static String? age(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.errAgeRequired;
    final int? number = int.tryParse(text);
    if (number == null || number < _minAge || number > _maxAge) {
      return AppStrings.errAgeInvalid;
    }
    return null;
  }

  /// Doctor specialty: required and at least 3 characters.
  static String? specialty(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.errSpecialtyRequired;
    if (text.length < _minNameLength) return AppStrings.errSpecialtyShort;
    return null;
  }

  /// Symptoms written by a patient: required and at least 10 characters.
  static String? symptoms(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return AppStrings.errSymptomsRequired;
    if (text.length < _minSymptomsLength) return AppStrings.errSymptomsShort;
    return null;
  }
}