import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retina_scan_app/res/constants/api_config.dart';
import 'package:retina_scan_app/res/responsive/responsive_extensions.dart';
import 'package:retina_scan_app/res/services/api_client.dart';

/// Shows a retina image from either:
/// - a server path (starts with /api/, loaded with the login token)
/// - a local file path (picked from camera / gallery on Mobile)
/// - a blob/web url (picked from gallery on Web)
/// A placeholder is shown when there is no image or it fails to load.
class ScanImage extends StatelessWidget {
  const ScanImage({super.key, required this.path, this.iconSize = 40});

  final String? path;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    // 1. Placeholder (agar image nahi hai)
    final Widget placeholder = Container(
      alignment: Alignment.center,
      color: scheme.primary.withValues(alpha: 0.08),
      child: Icon(
        Icons.remove_red_eye_rounded,
        size: iconSize.sz,
        color: scheme.primary,
      ),
    );

    final String? p = path;
    if (p == null || p.isEmpty) return placeholder;

    // 2. Server Image (Network)
    if (p.startsWith('/api/')) {
      return Image.network(
        '${ApiConfig.baseUrl}$p',
        headers: Get.find<ApiClient>().authHeaders,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 900,
        gaplessPlayback: true,
        errorBuilder: (BuildContext c, Object e, StackTrace? s) => placeholder,
        loadingBuilder: (BuildContext c, Widget child, ImageChunkEvent? progress) {
          if (progress == null) return child;
          return Container(
            alignment: Alignment.center,
            color: scheme.primary.withValues(alpha: 0.08),
            child: SizedBox(
              width: 24.sz,
              height: 24.sz,
              child: CircularProgressIndicator(strokeWidth: 2.5.sz),
            ),
          );
        },
      );
    }

    // 3. Local Image (Web)
    // Web par path ek blob URL hota hai (jaise "blob:http://localhost...").
    if (kIsWeb) {
      return Image.network(
        p,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (BuildContext c, Object e, StackTrace? s) => placeholder,
      );
    }

    // 4. Local Image (Mobile)
    // Mobile par path asli file path hota hai (jaise "/data/user/0/...").
    return Image.file(
      File(p),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      cacheWidth: 900,
      gaplessPlayback: true,
      errorBuilder: (BuildContext c, Object e, StackTrace? s) => placeholder,
    );
  }
}