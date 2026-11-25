/// Texts shown in permission dialogs and snackbars.
///
/// All strings used by [PermissionService] and permission-related screens
/// live here so they are easy to find, edit and translate.
class PermissionStrings {
  PermissionStrings._();

  // ---------------------------------------------------------------------------
  // Camera
  // ---------------------------------------------------------------------------
  static const String cameraTitle = 'Camera Permission Needed';
  static const String cameraMessage =
      'Retina Scan needs camera access to take a photo of your eye. '
      'Please allow camera access to continue.';
  static const String cameraDenied =
      'Camera permission denied. You can still pick an image from gallery.';

  // ---------------------------------------------------------------------------
  // Photos / storage
  // ---------------------------------------------------------------------------
  static const String photosTitle = 'Photo Access Needed';
  static const String photosMessage =
      'Retina Scan needs access to your photos so you can pick a retina '
      'image from the gallery.';
  static const String photosDenied =
      'Photo access denied. Open settings to allow it.';

  // ---------------------------------------------------------------------------
  // Settings redirect (permanently denied case)
  // ---------------------------------------------------------------------------
  static const String settingsTitle = 'Permission Required';
  static const String settingsMessage =
      'You have permanently denied this permission. Please open the app '
      'settings and enable it to continue.';
  static const String openSettings = 'Open Settings';
  static const String cancel = 'Cancel';
  static const String allow = 'Allow';
  static const String notNow = 'Not Now';
}