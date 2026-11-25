import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';

/// The two roles supported by the app.
enum UserRole {
  doctor,
  patient;

  /// Human readable name shown in the UI.
  String get label {
    switch (this) {
      case UserRole.doctor:
        return AppStrings.roleDoctor;
      case UserRole.patient:
        return AppStrings.rolePatient;
    }
  }

  /// Icon that represents the role.
  IconData get icon {
    switch (this) {
      case UserRole.doctor:
        return Icons.medical_services_rounded;
      case UserRole.patient:
        return Icons.person_rounded;
    }
  }
}