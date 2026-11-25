import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/models/onboarding_model.dart';
import 'package:retina_scan_app/res/components/app_button.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/components/app_page_indicator.dart';
import 'package:retina_scan_app/res/components/onboarding_illustration.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/responsive/responsive_builder.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/view_models/onboarding_controller.dart';

/// Introduces the app in a few swipeable pages.
///
/// Layout: skip bar (top), pages (middle), indicator + button (bottom).
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _SkipBar(controller: controller),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _OnboardingPage(model: controller.pages[index]);
                  },
                ),
              ),
              _BottomControls(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Skip" button at the top right. Fades out on the last page.
class _SkipBar extends StatelessWidget {
  const _SkipBar({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.sz, vertical: 4.sz),
      child: Align(
        alignment: Alignment.centerRight,
        // Space is always reserved, so the layout never jumps.
        child: Obx(() {
          final bool hidden = controller.isLastPage;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: hidden ? 0 : 1,
            child: IgnorePointer(
              ignoring: hidden,
              child: TextButton(
                onPressed: controller.skip,
                child: Text(
                  AppStrings.skip,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// One onboarding page. Scrolls if the screen is too small (no overflow).
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.model});

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.sz),
              child: Center(
                child: ResponsiveBuilder(
                  mobile: _PortraitContent(model: model),
                  landscape: _LandscapeContent(model: model),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Illustration on top, text below.
class _PortraitContent extends StatelessWidget {
  const _PortraitContent({required this.model});

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OnboardingIllustration(
          icon: model.icon,
          accentIcons: model.accentIcons,
        ),
        32.vSpace,
        _PageText(model: model, textAlign: TextAlign.center),
      ],
    );
  }
}

/// Illustration on the left, text on the right (short screens).
class _LandscapeContent extends StatelessWidget {
  const _LandscapeContent({required this.model});

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OnboardingIllustration(
          icon: model.icon,
          accentIcons: model.accentIcons,
          size: 170,
        ),
        24.hSpace,
        Expanded(
          child: _PageText(model: model, textAlign: TextAlign.start),
        ),
      ],
    );
  }
}

/// Title and description of a page.
class _PageText extends StatelessWidget {
  const _PageText({required this.model, required this.textAlign});

  final OnboardingModel model;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          model.title,
          textAlign: textAlign,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        12.vSpace,
        Text(
          model.description,
          textAlign: textAlign,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Page indicator and the Next / Get Started button.
class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.sz, 8.sz, 24.sz, 20.sz),
      child: ResponsiveBuilder(
        mobile: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Indicator(controller: controller),
            24.vSpace,
            _ActionButton(controller: controller),
          ],
        ),
        landscape: Row(
          children: <Widget>[
            _Indicator(controller: controller),
            const Spacer(),
            _ActionButton(controller: controller, width: 200),
          ],
        ),
      ),
    );
  }
}

/// Reactive page indicator.
class _Indicator extends StatelessWidget {
  const _Indicator({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => AppPageIndicator(
        count: controller.pages.length,
        currentIndex: controller.currentIndex.value,
      ),
    );
  }
}

/// Reactive button: "Next" on normal pages, "Get Started" on the last one.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.controller, this.width});

  final OnboardingController controller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLast = controller.isLastPage;
      return AppButton(
        width: width,
        label: isLast ? AppStrings.getStarted : AppStrings.next,
        icon: isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
        onPressed: controller.next,
      );
    });
  }
}