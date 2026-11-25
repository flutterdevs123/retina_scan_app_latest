import 'dart:async';

import 'package:get/get.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';

/// Handles the "verify your email" screen after sign up.
class VerifyEmailController extends GetxController {
  /// Seconds the user must wait between two resend taps.
  static const int _cooldownSeconds = 30;

  /// Email address the verification link was sent to.
  late final String email;

  /// Seconds left before resend is allowed again (0 = allowed now).
  final RxInt secondsLeft = 0.obs;

  /// True after the user pressed resend (shows a confirmation banner).
  final RxBool isResent = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // The sign up screen passes the new user as an argument.
    final dynamic args = Get.arguments;
    email = args is UserModel ? args.email : '';
  }

  /// Sends the verification email again, then starts the cooldown.
  void resendEmail() {
    if (secondsLeft.value > 0) return;

    // TODO: Call the real "resend verification email" API here.
    isResent.value = true;
    _startCooldown();
  }

  /// Opens the login screen and clears the back stack.
  void goToLogin() => Get.offAllNamed(AppRoutes.login);

  /// Counts down from [_cooldownSeconds] to 0.
  void _startCooldown() {
    _timer?.cancel();
    secondsLeft.value = _cooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      secondsLeft.value--;
      if (secondsLeft.value <= 0) timer.cancel();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}