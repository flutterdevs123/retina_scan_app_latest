import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_card.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/components/app_inline_message.dart';
import 'package:retina_scan_app/res/components/auth_footer_link.dart';
import 'package:retina_scan_app/res/components/auth_header.dart';
import 'package:retina_scan_app/res/components/responsive_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/verify_email_controller.dart';

/// Shown after sign up: asks the user to open the link sent to their inbox.
class VerifyEmailScreen extends GetView<VerifyEmailController> {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: AppGradientBackground(
        child: ResponsiveScrollBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              24.vSpace,
              const AuthHeader(
                icon: Icons.mark_email_unread_rounded,
                title: AppStrings.verifyTitle,
                subtitle: AppStrings.verifySubtitle,
              ),
              12.vSpace,
              // Shows which address received the link.
              Text(
                controller.email,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              24.vSpace,
              const _SpamTip(),
              28.vSpace,
              // Disabled while the cooldown is running.
              Obx(() {
                final int seconds = controller.secondsLeft.value;
                return AppButton(
                  label: seconds > 0
                      ? AppStrings.resendIn(seconds)
                      : AppStrings.resendEmail,
                  icon: Icons.refresh_rounded,
                  onPressed: seconds > 0 ? null : controller.resendEmail,
                );
              }),
              Obx(
                    () => controller.isResent.value
                    ? Padding(
                  padding: EdgeInsets.only(top: 12.sz),
                  child: const AppInlineMessage(
                    message: AppStrings.verifyResent,
                    isError: false,
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              // Pushes the footer to the bottom on tall screens.
              const Spacer(),
              24.vSpace,
              AuthFooterLink(
                message: AppStrings.alreadyVerified,
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

/// Reminder to check the spam / junk folder.
class _SpamTip extends StatelessWidget {
  const _SpamTip();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 22.sz,
            color: theme.colorScheme.primary,
          ),
          12.hSpace,
          Expanded(
            child: Text(
              AppStrings.verifySpamTip,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}