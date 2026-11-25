import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shared form logic for every controller that owns a form (DRY).
///
/// The controller only has to provide [textControllers].
mixin FormControllerMixin on GetxController {
  /// Key used by the `Form` widget to validate and reset fields.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// All text controllers of the form.
  List<TextEditingController> get textControllers;

  /// Runs every validator. Returns true when all fields are valid.
  bool validateForm() => formKey.currentState?.validate() ?? false;

  /// Closes the keyboard.
  void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  /// Removes typed text and old error messages from every field.
  /// Call this before moving to another screen.
  void clearForm() {
    for (final TextEditingController controller in textControllers) {
      controller.clear();
    }
    formKey.currentState?.reset();
  }
}