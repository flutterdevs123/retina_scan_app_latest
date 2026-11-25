import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/utils/form_controller_mixin.dart';

/// Handles the "send reset link" flow.
class ForgotPasswordController extends GetxController
    with FormControllerMixin {
  final TextEditingController emailController = TextEditingController();

  /// True after the reset link has been sent (switches to the success view).
  final RxBool isEmailSent = false.obs;

  /// True after the user pressed "Resend Link".
  final RxBool isResent = false.obs;

  /// Email address the link was sent to (shown in the success view).
  final RxString sentToEmail = ''.obs;

  @override
  List<TextEditingController> get textControllers =>
      <TextEditingController>[emailController];

  /// Validates the email and sends the reset link.
  void sendResetLink() {
    closeKeyboard();

    // Stop here if the validator returns an error.
    if (!validateForm()) return;

    // TODO: Call the real "forgot password" API here.
    sentToEmail.value = emailController.text.trim();
    isEmailSent.value = true;
  }

  /// Sends the link again to the same email.
  void resendLink() {
    // TODO: Call the real "forgot password" API here.
    isResent.value = true;
  }

  /// Returns to the email form with an empty field.
  void changeEmail() {
    clearForm();
    isResent.value = false;
    isEmailSent.value = false;
  }

  /// Goes back to the login screen (fields are cleared first).
  void goToLogin() {
    clearForm();
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}