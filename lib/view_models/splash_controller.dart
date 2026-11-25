import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls all splash animations and decides the first screen:
/// - Logged in  -> role dashboard
/// - First time -> onboarding
/// - Otherwise  -> login
class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  static const Duration _entranceDuration = Duration(milliseconds: 1000);
  static const Duration _loopDuration = Duration(milliseconds: 2600);
  static const Duration _splashDuration = Duration(seconds: 3);

  /// SharedPreferences key for "user has seen onboarding".
  static const String _onboardingKey = 'onboarding_seen';

  /// Plays once: logo and text appear.
  late final AnimationController entranceController;

  /// Repeats forever: drives pulse rings and the scan line.
  late final AnimationController loopController;

  /// Plays once: fills the progress bar, then opens the next screen.
  late final AnimationController progressController;

  late final Animation<double> logoFade;
  late final Animation<double> logoScale;
  late final Animation<double> textFade;
  late final Animation<Offset> textSlide;

  /// Session check runs in parallel with the animation.
  late final Future<bool> _sessionRestore;

  @override
  void onInit() {
    super.onInit();

    // Start restoring the session immediately (no UI blocking).
    _sessionRestore = Get.find<AuthService>().restoreSession();

    entranceController = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );
    loopController = AnimationController(
      vsync: this,
      duration: _loopDuration,
    );
    progressController = AnimationController(
      vsync: this,
      duration: _splashDuration,
    );

    // Logo appears first.
    logoFade = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Text follows slightly later.
    final CurvedAnimation textCurve = CurvedAnimation(
      parent: entranceController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    );
    textFade = textCurve;
    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(textCurve);

    // Move to the next screen when the progress bar is full.
    progressController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) _navigateToNext();
    });

    entranceController.forward();
    loopController.repeat();
    progressController.forward();
  }

  /// Decides where to go after the splash animation.
  ///
  /// - Session restored (token valid) -> role dashboard
  /// - First time user -> onboarding (and mark as seen)
  /// - Otherwise -> login
  Future<void> _navigateToNext() async {
    final bool restored = await _sessionRestore;
    final AuthService auth = Get.find<AuthService>();

    // 1. Already logged in? Go straight to the dashboard.
    if (restored && auth.currentUser.value != null) {
      Get.offAllNamed(
        AppRoutes.dashboardFor(auth.currentUser.value!.role),
      );
      return;
    }

    // 2. First time? Show onboarding.
    final SharedPreferences prefs =
    await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool(_onboardingKey) ?? false;
    if (!seenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // 3. Returning user, not logged in -> login.
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    entranceController.dispose();
    loopController.dispose();
    progressController.dispose();
    super.onClose();
  }
}