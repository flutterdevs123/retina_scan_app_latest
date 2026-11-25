import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/components/app_back_button.dart';
import 'package:retina_scan_app/res/components/app_gradient_background.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';

/// Frame for screens opened ON TOP of the dashboard (details, edit, etc.).
///
/// Layout: back button + title (top), scrollable [children] (middle) and an
/// optional pinned [bottom] widget such as an action button.
class AppInnerScaffold extends StatelessWidget {
  const AppInnerScaffold({
    super.key,
    required this.title,
    required this.children,
    this.bottom,
    this.trailing,
  });

  /// Screen title.
  final String title;

  /// Scrollable content.
  final List<Widget> children;

  /// Widget pinned under the content (for example action buttons).
  final Widget? bottom;

  /// Widget at the end of the title row (for example a text button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.sz, 12.sz, 20.sz, 8.sz),
                child: Row(
                  children: <Widget>[
                    AppBackButton(onPressed: () => Get.back()),
                    14.hSpace,
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(20.sz, 8.sz, 20.sz, 24.sz),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
              if (bottom != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(20.sz, 8.sz, 20.sz, 16.sz),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}