import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/components/app_back_button.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/app_text_field.dart';
import 'package:retina_scan_app/res/components/auth_footer_link.dart';
import 'package:retina_scan_app/res/components/auth_header.dart';
import 'package:retina_scan_app/res/components/responsive_scroll_body.dart';
import 'package:retina_scan_app/res/components/role_selector.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/validators.dart';
import 'package:retina_scan_app/view_models/signup_controller.dart';

/// Sign up screen: role, name, email, (specialty), password, confirm password.
class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: ResponsiveScrollBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: AppBackButton(onPressed: controller.goToLogin),
              ),
              16.vSpace,
              const AuthHeader(
                title: AppStrings.signupTitle,
                subtitle: AppStrings.signupSubtitle,
              ),
              32.vSpace,
              _SignupForm(controller: controller),
              const Spacer(),
              24.vSpace,
              AuthFooterLink(
                message: AppStrings.haveAccount,
                actionLabel: AppStrings.logIn,
                onPressed: controller.goToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({required this.controller});

  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Obx(
                () => RoleSelector(
              selected: controller.selectedRole.value,
              onChanged: controller.selectRole,
            ),
          ),
          16.vSpace,
          AppTextField(
            controller: controller.nameController,
            label: AppStrings.fullNameLabel,
            hint: AppStrings.fullNameHint,
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: Validators.fullName,
          ),
          16.vSpace,
          AppTextField(
            controller: controller.emailController,
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
          ),
          // Doctors also enter their specialty.
          Obx(
                () => controller.selectedRole.value == UserRole.doctor
                ? Padding(
              padding: EdgeInsets.only(top: 16.sz),
              child: AppTextField(
                controller: controller.specialtyController,
                label: AppStrings.specialtyLabel,
                hint: AppStrings.specialtyHint,
                prefixIcon: Icons.medical_services_outlined,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: Validators.specialty,
              ),
            )
                : const SizedBox.shrink(),
          ),
          16.vSpace,
          AppTextField(
            controller: controller.passwordController,
            label: AppStrings.passwordLabel,
            hint: AppStrings.newPasswordHint,
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: Validators.newPassword,
          ),
          16.vSpace,
          AppTextField(
            controller: controller.confirmPasswordController,
            label: AppStrings.confirmPasswordLabel,
            hint: AppStrings.confirmPasswordHint,
            prefixIcon: Icons.lock_reset_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: (String? value) =>
                Validators.confirmPassword(value, controller.password),
            onSubmitted: (_) => controller.signUp(),
          ),
          Obx(() {
            final String? error = controller.errorMessage.value;
            if (error == null) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 16.sz),
              child: AppInlineMessage(message: error),
            );
          }),
          28.vSpace,
          Obx(
                () => AppButton(
              label: AppStrings.createAccount,
              isLoading: controller.isLoading.value,
              onPressed: controller.signUp,
            ),
          ),
        ],
      ),
    );
  }
}