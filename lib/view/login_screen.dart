import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/app_text_field.dart';
import 'package:retina_scan_app/res/components/auth_footer_link.dart';
import 'package:retina_scan_app/res/components/auth_header.dart';
import 'package:retina_scan_app/res/components/responsive_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/utils/validators.dart';
import 'package:retina_scan_app/view_models/login_controller.dart';

/// Login screen: email, password, forgot password link and sign up link.
class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: ResponsiveScrollBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              24.vSpace,
              const AuthHeader(
                title: AppStrings.loginTitle,
                subtitle: AppStrings.loginSubtitle,
              ),
              32.vSpace,
              _LoginForm(controller: controller),
              // Pushes the footer to the bottom on tall screens.
              const Spacer(),
              24.vSpace,
              AuthFooterLink(
                message: AppStrings.noAccount,
                actionLabel: AppStrings.signUp,
                onPressed: controller.goToSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Email + password fields, error banner and the login button.
class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.controller});

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTextField(
            controller: controller.emailController,
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
          ),
          16.vSpace,
          AppTextField(
            controller: controller.passwordController,
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            textInputAction: TextInputAction.done,
            validator: Validators.requiredPassword,
            onSubmitted: (_) => controller.login(),
          ),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.goToForgotPassword,
              child: Text(
                AppStrings.forgotPassword,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          // Wrong email / password message (no snackbar).
          Obx(() {
            final String? error = controller.loginError.value;
            if (error == null) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: 12.sz),
              child: AppInlineMessage(message: error),
            );
          }),
          AppButton(
            label: AppStrings.logIn,
            onPressed: controller.login,
          ),
        ],
      ),
    );
  }
}