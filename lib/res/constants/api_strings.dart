/// Texts used by the backend integration.
class ApiStrings {
  ApiStrings._();

  // Errors
  static const String errNetwork =
      'Cannot reach the server. Check your Wi-Fi and make sure the server is running.';
  static const String errTimeout =
      'The server took too long to respond. Please try again.';
  static const String errUnexpected =
      'Unexpected server response. Please try again.';
  static const String errUnsupportedRole =
      'This account type is not supported in the app.';
  static const String errNoScan = 'No scan is attached to this request.';
  static String errServer(int code) => 'Server error ($code). Please try again.';

  // Grades returned by the AI model (order matters: index 0..4)
  static const List<String> grades = <String>[
    'No DR',
    'Mild',
    'Moderate',
    'Severe',
    'Proliferative',
  ];

  // Report / scan
  static const String statusDraft = 'Draft';
  static const String notSent = 'Not sent yet';
  static const String labelScanned = 'Scanned';
  static const String doctorGradeLabel = "Doctor's Grade";
  static const String finalGradeLabel = 'Final Grade';
  static const String yourGrade = 'Your Grade (optional)';
  static const String sameAsAi = 'Same as AI';
  static const String deleteScan = 'Delete Scan';
  static const String probabilitiesTitle = 'Grade Probabilities';
  static const String qualityWarningTitle = 'Image quality warning';
  static const String lowConfidenceWarning =
      'The model has low confidence. A doctor review is strongly advised.';
  static const String originalTab = 'Original';
  static const String heatmapTab = 'AI Heatmap';
  static const String conditionNone = 'No Diabetic Retinopathy';
  static String conditionOf(String grade) => '$grade Diabetic Retinopathy';
}