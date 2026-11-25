import 'package:retina_scan_app/models/scan_result_model.dart';

/// Arguments passed to the "send to doctor" screen.
class CreateRequestArgs {
  const CreateRequestArgs({required this.doctorId, this.scan});

  /// Doctor who will receive the request.
  final String doctorId;

  /// AI result that is attached to the request.
  final ScanResultModel? scan;
}