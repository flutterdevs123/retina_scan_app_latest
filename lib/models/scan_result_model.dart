import 'package:retina_scan_app/models/risk_level.dart';
import 'package:retina_scan_app/res/constants/api_strings.dart';
import 'package:retina_scan_app/res/constants/scan_strings.dart';

/// AI result of one retina scan (as returned by the FastAPI model).
class ScanResultModel {
  const ScanResultModel({
    required this.scanId,
    required this.imagePath,
    required this.heatmapPath,
    required this.grade,
    required this.gradeIndex,
    required this.confidence,
    required this.probabilities,
    required this.qualityOk,
    required this.qualityWarnings,
    required this.lowConfidence,
    required this.analyzedAt,
  });

  /// Numeric scan ID on the server.
  final int scanId;

  /// Server path of the original image, e.g. /api/v1/scans/4/image/original
  final String imagePath;
  final String? heatmapPath;

  /// "No DR", "Mild", "Moderate", "Severe" or "Proliferative".
  final String grade;
  final int gradeIndex;

  /// 0.0 to 1.0.
  final double confidence;

  /// Percent per grade (0 to 100), in the server's order.
  final Map<String, double> probabilities;

  final bool qualityOk;
  final List<String> qualityWarnings;
  final bool lowConfidence;
  final DateTime analyzedAt;

  /// Overall risk used for colors and badges.
  RiskLevel get risk => riskForIndex(gradeIndex);

  /// Readable condition name.
  String get condition => gradeIndex == 0
      ? ApiStrings.conditionNone
      : ApiStrings.conditionOf(grade);

  /// Advice shown under the result.
  String get recommendation => switch (risk) {
    RiskLevel.low => ScanStrings.recLow,
    RiskLevel.moderate => ScanStrings.recModerate,
    RiskLevel.high => ScanStrings.recHigh,
  };

  /// Grade 0 = low, 1-2 = moderate, 3-4 = high.
  static RiskLevel riskForIndex(int index) {
    if (index <= 0) return RiskLevel.low;
    if (index <= 2) return RiskLevel.moderate;
    return RiskLevel.high;
  }

  factory ScanResultModel.fromJson(Map<String, dynamic> j) {
    final int scanId = (j['id'] as num?)?.toInt() ?? 0;
    final Map<dynamic, dynamic> images =
    j['images'] is Map ? j['images'] as Map : const <dynamic, dynamic>{};
    final Map<dynamic, dynamic> quality =
    j['quality'] is Map ? j['quality'] as Map : const <dynamic, dynamic>{};

    final Map<String, double> probs = <String, double>{};
    if (j['probabilities'] is Map) {
      (j['probabilities'] as Map).forEach((dynamic k, dynamic v) {
        probs['$k'] = (v is num) ? v.toDouble() : 0;
      });
    }

    final String grade = (j['predicted_grade'] ?? ApiStrings.grades.first).toString();
    int index = (j['predicted_index'] as num?)?.toInt() ??
        ApiStrings.grades.indexOf(grade);
    if (index < 0) index = 0;

    final double rawConfidence = (j['confidence'] as num?)?.toDouble() ?? 0;

    return ScanResultModel(
      scanId: scanId,
      imagePath: (images['original'] ?? '/api/v1/scans/$scanId/image/original').toString(),
      heatmapPath: (images['heatmap'] ?? '/api/v1/scans/$scanId/image/heatmap').toString(),
      grade: grade,
      gradeIndex: index,
      confidence: (rawConfidence / 100).clamp(0.0, 1.0).toDouble(),
      probabilities: probs,
      qualityOk: quality['ok'] != false,
      qualityWarnings: quality['warnings'] is List
          ? (quality['warnings'] as List).map((dynamic e) => '$e').toList()
          : const <String>[],
      lowConfidence: j['low_confidence'] == true,
      analyzedAt: DateTime.tryParse('${j['created_at']}')?.toLocal() ?? DateTime.now(),
    );
  }
}