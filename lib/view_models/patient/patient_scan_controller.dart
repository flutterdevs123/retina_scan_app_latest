import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/res/constants/permission_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';
import 'package:retina_scan_app/res/routes/app_routes.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/services/permission_service.dart';
import 'package:retina_scan_app/res/services/scan_analysis_service.dart';
import 'package:retina_scan_app/view_models/base_user_controller.dart';

/// The three states of the scan tab.
enum ScanStage { idle, analyzing, result }

/// Pick an image -> upload it to the AI model -> show the result ->
/// continue to "send to a doctor".
class PatientScanController extends BaseUserController {
  final ImagePicker _picker = ImagePicker();
  final ScanAnalysisService _service = Get.find<ScanAnalysisService>();
  final PermissionService _permissions = Get.find<PermissionService>();

  final Rx<ScanStage> stage = ScanStage.idle.obs;

  /// Local path of the selected image (shown while analyzing).
  final Rxn<String> imagePath = Rxn<String>();

  /// Result returned by the AI model.
  final Rxn<ScanResultModel> result = Rxn<ScanResultModel>();

  final Rxn<String> errorMessage = Rxn<String>();

  /// Opens the camera or gallery (with permission check), then analyzes.
  Future<void> pickImage(ImageSource source) async {
    if (stage.value == ScanStage.analyzing) return;
    errorMessage.value = null;

    // 1. Permissions ka masla sirf mobile par hota hai (Web par browser handle karta hai)
    if (!kIsWeb) {
      final bool allowed = await _ensurePermission(source);
      if (!allowed) return;
    }

    // 2. Open the system picker (Web par File Explorer khulega, Mobile par Camera/Gallery)
    XFile? file;
    try {
      file = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
    } catch (e) {
      debugPrint('Image Picker Error: $e');
      errorMessage.value = ScanStrings.pickError;
      return;
    }

    // User closed the picker without choosing anything.
    if (file == null) return;

    // 3. Send the image to the AI model.
    await _analyze(
      file.path,
      source == ImageSource.camera ? 'camera' : 'upload',
    );
  }

  /// Asks for camera or photo permission and shows a friendly message
  /// when the user denies it. (Sirf Mobile ke liye)
  Future<bool> _ensurePermission(ImageSource source) async {
    final PermissionResult result = source == ImageSource.camera
        ? await _permissions.requestCamera()
        : await _permissions.requestPhotos();

    switch (result) {
      case PermissionResult.granted:
        return true;

      case PermissionResult.denied:
        errorMessage.value = source == ImageSource.camera
            ? PermissionStrings.cameraDenied
            : PermissionStrings.photosDenied;
        return false;

      case PermissionResult.permanentlyDenied:
      // Ask the user to open settings (one-time dialog).
        final bool? open = await Get.dialog<bool>(
          AlertDialog(
            title: const Text(PermissionStrings.settingsTitle),
            content: const Text(PermissionStrings.settingsMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back<bool>(result: false),
                child: const Text(PermissionStrings.cancel),
              ),
              TextButton(
                onPressed: () => Get.back<bool>(result: true),
                child: const Text(PermissionStrings.openSettings),
              ),
            ],
          ),
        );
        if (open == true) await _permissions.openSettings();
        return false;

      case PermissionResult.unavailable:
        errorMessage.value = ScanStrings.pickError;
        return false;
    }
  }

  Future<void> _analyze(String path, String source) async {
    imagePath.value = path;
    stage.value = ScanStage.analyzing;
    try {
      final ReportModel report = await _service.analyze(path, source: source);
      // The draft also shows up in My Reports.
      data.upsertReport(report);
      result.value = report.scan;
      stage.value = ScanStage.result;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      stage.value = ScanStage.idle;
    } catch (e) {
      debugPrint('Analysis Error: $e');
      errorMessage.value = ScanStrings.analyzeError;
      stage.value = ScanStage.idle;
    }
  }

  /// Goes back to the start so a new image can be scanned.
  void reset() {
    stage.value = ScanStage.idle;
    imagePath.value = null;
    result.value = null;
    errorMessage.value = null;
  }

  /// Opens the doctor list with this result attached.
  void sendToDoctor() {
    final ScanResultModel? current = result.value;
    if (current == null) return;
    Get.toNamed(AppRoutes.selectDoctor, arguments: current);
  }
}