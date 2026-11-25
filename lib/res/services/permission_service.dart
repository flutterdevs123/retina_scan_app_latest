import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a permission request.
enum PermissionResult {
  /// User granted the permission.
  granted,

  /// User denied once (can ask again).
  denied,

  /// User denied permanently — must open settings.
  permanentlyDenied,

  /// The device has no camera (rare, but possible).
  unavailable,
}

/// Asks for camera / photo permissions with a friendly flow.
///
/// Usage in a controller:
/// ```dart
/// final PermissionResult result = await Get.find<PermissionService>().requestCamera();
/// if (result != PermissionResult.granted) return;
/// ```
class PermissionService extends GetxService {
  /// Requests the camera permission.
  Future<PermissionResult> requestCamera() async {
    final PermissionStatus status = await Permission.camera.request();
    return _toResult(status);
  }

  /// Requests photo library access (Android 13+ / iOS 14+ safe).
  Future<PermissionResult> requestPhotos() async {
    // Android 13+ uses Permission.photos; older uses Permission.storage.
    // permission_handler handles the fallback automatically when you ask
    // for photos.
    final PermissionStatus photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return PermissionResult.granted;
    if (photos.isPermanentlyDenied) return PermissionResult.permanentlyDenied;
    if (photos.isDenied) return PermissionResult.denied;

    // Fallback for older Android (pre-13): ask for storage.
    final PermissionStatus storage = await Permission.storage.request();
    return _toResult(storage);
  }

  /// Returns true if the user can still be asked again (not permanently denied).
  Future<bool> canAskAgain(Permission permission) async {
    final PermissionStatus status = await permission.status;
    return !status.isPermanentlyDenied;
  }

  /// Opens the system settings page for this app.
  Future<bool> openSettings() => openAppSettings();

  PermissionResult _toResult(PermissionStatus status) {
    if (status.isGranted || status.isLimited) return PermissionResult.granted;
    if (status.isPermanentlyDenied) return PermissionResult.permanentlyDenied;
    if (status.isRestricted) return PermissionResult.unavailable;
    return PermissionResult.denied;
  }
}