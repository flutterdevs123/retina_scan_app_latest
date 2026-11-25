import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:retina_scan_app/res/utils/form_controller_mixin.dart';

/// Creates the account through the API, logs in and opens the dashboard.
class SignupController extends GetxController with FormControllerMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  /// Only used when the role is doctor.
  final TextEditingController specialtyController = TextEditingController();

  final Rx<UserRole> selectedRole = UserRole.patient.obs;
  final RxBool isLoading = false.obs;

  /// Server error (for example "email already registered").
  final Rxn<String> errorMessage = Rxn<String>();

  @override
  List<TextEditingController> get textControllers => <TextEditingController>[
    nameController,
    emailController,
    passwordController,
    confirmPasswordController,
    specialtyController,
  ];

  /// Current password text, used by the confirm password validator.
  String get password => passwordController.text;

  void selectRole(UserRole role) {
    selectedRole.value = role;
    errorMessage.value = null;
  }

  Future<void> signUp() async {
    closeKeyboard();
    if (isLoading.value || !validateForm()) return;

    isLoading.value = true;
    errorMessage.value = null;
    try {
      final UserModel user = await Get.find<AuthService>().register(
        name: nameController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text,
        role: selectedRole.value,
        specialty: specialtyController.text.trim(),
      );
      clearForm();
      // Clears the whole back stack and opens the dashboard.
      Get.offAllNamed(AppRoutes.dashboardFor(user.role));
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    clearForm();
    errorMessage.value = null;
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    specialtyController.dispose();
    super.onClose();
  }
}