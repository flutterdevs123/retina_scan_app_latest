import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:retina_scan_app/res/utils/form_controller_mixin.dart';

/// Logs in through the API and opens the dashboard of the user's role.
class LoginController extends GetxController with FormControllerMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// True while the request is running.
  final RxBool isLoading = false.obs;

  /// Error shown above the login button.
  final Rxn<String> loginError = Rxn<String>();

  @override
  List<TextEditingController> get textControllers =>
      <TextEditingController>[emailController, passwordController];

  @override
  void onInit() {
    super.onInit();
    // Hide the old error as soon as the user edits any field.
    emailController.addListener(_clearError);
    passwordController.addListener(_clearError);
  }

  Future<void> login() async {
    closeKeyboard();
    if (isLoading.value || !validateForm()) return;

    isLoading.value = true;
    loginError.value = null;
    try {
      final UserModel user = await Get.find<AuthService>().login(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text,
      );
      clearForm();
      // Removes login from the back stack and opens the role dashboard.
      Get.offAllNamed(AppRoutes.dashboardFor(user.role));
    } on ApiException catch (e) {
      // Print to console for exact diagnosis
      debugPrint('========================================');
      debugPrint('LOGIN FAILED!');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('STATUS CODE: ${e.statusCode}');
      debugPrint('========================================');

      // Show on screen
      loginError.value = e.message;
    } catch (e) {
      // In case of any other unexpected error
      debugPrint('UNEXPECTED LOGIN ERROR: $e');
      loginError.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void goToForgotPassword() {
    _resetScreen();
    Get.toNamed(AppRoutes.forgotPassword);
  }

  void goToSignUp() {
    _resetScreen();
    Get.toNamed(AppRoutes.signUp);
  }

  void _resetScreen() {
    clearForm();
    loginError.value = null;
  }

  void _clearError() {
    if (loginError.value != null) loginError.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}