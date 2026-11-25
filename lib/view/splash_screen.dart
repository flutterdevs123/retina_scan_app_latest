import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/components/app_logo.dart';
import 'package:retina_scan_app/res/components/pulse_rings.dart';
import 'package:retina_scan_app/res/components/responsive_scroll_body.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_builder.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/splash_controller.dart';

/// First screen of the app: animated logo, brand text and a progress bar.
/// Has separate layouts for portrait and landscape.
class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: ResponsiveScrollBody(
          child: ResponsiveBuilder(
            mobile: _PortraitLayout(controller: controller),
            landscape: _LandscapeLayout(controller: controller),
          ),
        ),
      ),
    );
  }
}

/// Logo on top, text in the middle, progress at the bottom.
class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Spacer(flex: 3),
        _SplashLogo(controller: controller, logoSize: 104),
        16.vSpace,
        _SplashBrand(controller: controller, textAlign: TextAlign.center),
        const Spacer(flex: 3),
        _SplashProgress(controller: controller),
        16.vSpace,
      ],
    );
  }
}

/// Logo on the left, text and progress on the right (short screens).
class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({required this.controller});

  final SplashController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _SplashLogo(controller: controller, logoSize: 84),
        8.hSpace,
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _SplashBrand(controller: controller, textAlign: TextAlign.start),
              24.vSpace,
              _SplashProgress(
                controller: controller,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Logo with pulse rings behind it.
class _SplashLogo extends StatelessWidget {
  const _SplashLogo({required this.controller, required this.logoSize});

  final SplashController controller;

  /// Design size of the logo; rings are drawn 2.2x bigger around it.
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final Color ringColor = Theme.of(context).colorScheme.primary;
    final double ringsSize = (logoSize * 2.2).sz;

    return SizedBox(
      width: ringsSize,
      height: ringsSize,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PulseRings(
            animation: controller.loopController,
            color: ringColor,
            size: ringsSize,
          ),
          FadeTransition(
            opacity: controller.logoFade,
            child: ScaleTransition(
              scale: controller.logoScale,
              child: AppLogo(
                size: logoSize,
                scanAnimation: controller.loopController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// App name and tagline.
class _SplashBrand extends StatelessWidget {
  const _SplashBrand({required this.controller, required this.textAlign});

  final SplashController controller;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CrossAxisAlignment alignment = textAlign == TextAlign.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return FadeTransition(
      opacity: controller.textFade,
      child: SlideTransition(
        position: controller.textSlide,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: alignment,
          children: <Widget>[
            Text(
              AppStrings.appName,
              textAlign: textAlign,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            10.vSpace,
            Text(
              AppStrings.splashTagline,
              textAlign: textAlign,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slim progress bar with a loading message.
class _SplashProgress extends StatelessWidget {
  const _SplashProgress({
    required this.controller,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final SplashController controller;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        AnimatedBuilder(
          animation: controller.progressController,
          builder: (BuildContext context, Widget? child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.sz),
              child: SizedBox(
                width: 160.sz,
                child: LinearProgressIndicator(
                  value: controller.progressController.value,
                  minHeight: 4.sz,
                  color: theme.colorScheme.primary,
                  backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
            );
          },
        ),
        12.vSpace,
        Text(
          AppStrings.splashLoading,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}