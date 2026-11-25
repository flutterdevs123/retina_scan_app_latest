import 'package:flutter/material.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Reusable text field used across the whole app.
///
/// Shows a label above the field, an icon inside it, the validator error
/// below it and (for passwords) a show / hide toggle.
///
/// Usage:
/// ```dart
/// AppTextField(
///   controller: emailController,
///   label: 'Email',
///   hint: 'you@example.com',
///   prefixIcon: Icons.mail_outline_rounded,
///   validator: Validators.email,
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.isPassword = false,
    this.enabled = true,
    this.minLines,
    this.maxLines = 1,
  });

  /// Holds the typed text.
  final TextEditingController controller;

  /// Title shown above the field.
  final String label;

  /// Placeholder shown while the field is empty.
  final String hint;

  /// Icon shown at the start of the field.
  final IconData prefixIcon;

  /// Returns an error message, or null when the value is valid.
  final FormFieldValidator<String>? validator;

  /// Keyboard type (email, text, number...).
  final TextInputType? keyboardType;

  /// Keyboard action button. `next` moves focus to the next field.
  final TextInputAction? textInputAction;

  /// Capitalization of typed text (for example words for names).
  final TextCapitalization textCapitalization;

  /// Called when the keyboard "done" button is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Hides the text and shows a visibility toggle.
  final bool isPassword;

  /// Disables typing (for example while loading).
  final bool enabled;

  /// Minimum visible lines (for notes and descriptions).
  final int? minLines;

  /// Maximum visible lines. Values above 1 make a multi-line field.
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// True while the password text is hidden.
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    // Password fields must always be single line.
    final int lines = widget.isPassword ? 1 : widget.maxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        8.vSpace,
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          validator: widget.validator,
          keyboardType: lines > 1 ? TextInputType.multiline : widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          onFieldSubmitted: widget.onSubmitted,
          minLines: widget.minLines,
          maxLines: lines,
          obscureText: widget.isPassword && _obscure,
          // Suggestions are disabled for passwords for safety.
          enableSuggestions: !widget.isPassword,
          autocorrect: !widget.isPassword,
          // Validate live, but only after the user has touched the field.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorMaxLines: 2,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.sz,
              vertical: 16.sz,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              size: 22.sz,
              color: scheme.onSurfaceVariant,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 22.sz,
                color: scheme.onSurfaceVariant,
              ),
            )
                : null,
          ),
        ),
      ],
    );
  }
}