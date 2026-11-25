import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/models/scan_result_model.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';

/// A scan on the server: AI result + (after submit) the doctor's review.
class ReportModel {
  const ReportModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.symptoms,
    required this.status,
    required this.createdAt,
    this.submittedAt,
    this.reviewedAt,
    this.doctorNote = '',
    this.doctorGrade,
    this.finalGrade,
    this.scan,
  });

  /// Looks like "RPT-4" (server ID with prefix).
  final String id;
  final String patientId;
  final String patientName;

  /// Empty while the scan is still a draft.
  final String doctorId;
  final String doctorName;

  /// Story written by the patient.
  final String symptoms;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String doctorNote;
  final String? doctorGrade;
  final String? finalGrade;
  final ScanResultModel? scan;

  /// Numeric server ID.
  int get apiId => int.tryParse(id.split('-').last) ?? 0;

  /// Date used for sorting (newest first).
  DateTime get sortDate => submittedAt ?? createdAt;

  static DateTime? _date(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString())?.toLocal();

  static Map<String, dynamic>? _map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : null;

  factory ReportModel.fromJson(Map<String, dynamic> j) {
    final Map<String, dynamic>? patient = _map(j['patient']);
    final Map<String, dynamic>? doctor = _map(j['doctor']);

    // Server ID might be missing in some edge cases — fall back to 0 safely.
    final int serverId = (j['id'] as num?)?.toInt() ?? 0;

    final ScanResultModel scan = ScanResultModel.fromJson(j);

    return ReportModel(
      id: 'RPT-$serverId',
      patientId: patient == null
          ? ''
          : UserModel.makeId(UserRole.patient, patient['id']),
      patientName: (patient?['name'] ?? '').toString(),
      doctorId: doctor == null
          ? ''
          : UserModel.makeId(UserRole.doctor, doctor['id']),
      doctorName: (doctor?['name'] ?? ApiStrings.notSent).toString(),
      symptoms: (j['patient_notes'] ?? '').toString(),
      status: ReportStatus.fromApi(j['status']?.toString()),
      createdAt: _date(j['created_at']) ?? DateTime.now(),
      submittedAt: _date(j['submitted_at']),
      reviewedAt: _date(j['reviewed_at']),
      doctorNote: (j['doctor_comment'] ?? '').toString(),
      doctorGrade: j['doctor_grade']?.toString(),
      finalGrade: j['final_grade']?.toString(),
      scan: scan,
    );
  }
}