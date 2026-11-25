import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_back_button.dart';
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
import 'package:retina_scan_app/view_models/forgot_password_controller.dart';

/// Forgot password screen.
/// Step 1: user types an email. Step 2: a success message is shown.
class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

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
              Obx(
                    () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: controller.isEmailSent.value
                      ? _SuccessView(
                    key: const ValueKey<String>('sent'),
                    controller: controller,
                  )
                      : _RequestView(
                    key: const ValueKey<String>('request'),
                    controller: controller,
                  ),
                ),
              ),
              // Pushes the footer to the bottom on tall screens.
              const Spacer(),
              24.vSpace,
              AuthFooterLink(
                message: AppStrings.rememberPassword,
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

/// Step 1: email field and "Send Reset Link" button.
class _RequestView extends StatelessWidget {
  const _RequestView({super.key, required this.controller});

  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AuthHeader(
          icon: Icons.lock_reset_rounded,
          title: AppStrings.forgotTitle,
          subtitle: AppStrings.forgotSubtitle,
        ),
        32.vSpace,
        Form(
          key: controller.formKey,
          child: AppTextField(
            controller: controller.emailController,
            label: AppStrings.emailLabel,
            hint: AppStrings.emailHint,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: Validators.email,
            onSubmitted: (_) => controller.sendResetLink(),
          ),
        ),
        28.vSpace,
        AppButton(
          label: AppStrings.sendResetLink,
          onPressed: controller.sendResetLink,
        ),
      ],
    );
  }
}

/// Step 2: confirmation that the email was sent.
class _SuccessView extends StatelessWidget {
  const _SuccessView({super.key, required this.controller});

  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AuthHeader(
          icon: Icons.mark_email_read_rounded,
          title: AppStrings.resetSentTitle,
          subtitle: AppStrings.resetSentDesc,
        ),
        12.vSpace,
        // Shows which address received the link.
        Obx(
              () => Text(
            controller.sentToEmail.value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        32.vSpace,
        AppButton(
          label: AppStrings.backToLogin,
          onPressed: controller.goToLogin,
        ),
        Obx(
              () => controller.isResent.value
              ? Padding(
            padding: EdgeInsets.only(top: 12.sz),
            child: const AppInlineMessage(
              message: AppStrings.resetResent,
              isError: false,
            ),
          )
              : const SizedBox.shrink(),
        ),
        12.vSpace,
        TextButton(
          onPressed: controller.resendLink,
          child: Text(
            AppStrings.resendLink,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: controller.changeEmail,
          child: Text(
            AppStrings.useDifferentEmail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}