import 'package:flutter/material.dart';

/// Data of a single onboarding page.
class OnboardingModel {
  const OnboardingModel({
    required this.icon,
    required this.accentIcons,
    required this.title,
    required this.description,
  });

  /// Main icon shown in the center of the illustration.
  final IconData icon;

  /// Small decorative icons floating around the main icon (max 2 are used).
  final List<IconData> accentIcons;

  /// Page heading.
  final String title;

  /// Short explanation under the heading.
  final String description;
}