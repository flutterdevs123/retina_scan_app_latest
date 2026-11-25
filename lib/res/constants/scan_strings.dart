/// Texts of the AI scan feature (scan screen, result card, send to doctor).
class ScanStrings {
  ScanStrings._();

  // Navigation and scan screen
  static const String navScan = 'Scan';
  static const String scanTitle = 'AI Retina Scan';
  static const String scanSubtitle = 'Get instant results, then share with a doctor';
  static const String heroTitle = 'Upload a retina photo';
  static const String heroDesc =
      'Our AI model checks your image and shows results in seconds.';
  static const String takePhoto = 'Take Photo';
  static const String fromGallery = 'From Gallery';
  static const String tipsTitle = 'Tips for a good scan';
  static const String tip1 = 'Use bright and even lighting';
  static const String tip2 = 'Keep the camera steady and in focus';
  static const String tip3 = 'Avoid flash glare on the image';
  static const String analyzingTitle = 'Analyzing your retina...';
  static const String analyzingDesc = 'This only takes a few seconds';
  static const String pickError =
      'Could not open the camera or gallery. Please check app permissions.';
  static const String analyzeError = 'Analysis failed. Please try again.';

  // Result
  static const String resultTitle = 'AI Screening Result';
  static const String confidenceLabel = 'Confidence';
  static const String findingsTitle = 'Detailed Findings';
  static const String disclaimer =
      'This is an AI screening, not a medical diagnosis. Please confirm '
      'with a doctor.';
  static const String sendToDoctor = 'Send to a Doctor';
  static const String scanAnother = 'Scan Another Image';
  static const String highRiskHint =
      'We recommend sending this report to a doctor for confirmation.';
  static const String lowRiskHint =
      'Looks fine, but you can still ask a doctor to confirm.';
  static const String aiAnalysis = 'AI Analysis';
  static const String retinaScan = 'Retina Scan';

  static String confidenceValue(double c) => '${(c * 100).round()}% confidence';
  static String confidencePercent(double c) => '${(c * 100).round()}%';

  // Risk levels
  static const String riskLow = 'Low Risk';
  static const String riskModerate = 'Moderate Risk';
  static const String riskHigh = 'High Risk';

  // Sample conditions, findings and advice (demo model)
  static const String condNormal = 'No Significant Abnormality';
  static const String condMild = 'Possible Mild Diabetic Retinopathy';
  static const String condAdvanced = 'Possible Advanced Retinal Damage';

  static const String fOpticDisc = 'Optic Disc';
  static const String fVessels = 'Blood Vessels';
  static const String fMacula = 'Macula';
  static const String fHemorrhages = 'Hemorrhages';

  static const String vNormal = 'Normal';
  static const String vNone = 'None detected';
  static const String vMicroaneurysms = 'Microaneurysms';
  static const String vSmallSpots = 'Small spots';
  static const String vSwelling = 'Swelling suspected';
  static const String vAbnormalGrowth = 'Abnormal growth';
  static const String vFluid = 'Fluid suspected';
  static const String vMultiple = 'Multiple detected';

  static const String recLow =
      'Your retina looks healthy. Continue with a routine yearly checkup.';
  static const String recModerate =
      'Early changes were noticed. Please consult a doctor within the next '
      'few weeks.';
  static const String recHigh =
      'Serious changes were noticed. Please send this report to a doctor '
      'as soon as possible.';

  // Choose doctor and send request
  static const String chooseDoctorTitle = 'Choose a Doctor';
  static const String attachedScan = 'Attached Scan';
  static const String storyLabel = 'Tell Your Story';
  static const String storyHint =
      'Describe your symptoms, when they started and any medical history';
  static const String quickAdd = 'Quick add';
  static const List<String> symptomChips = <String>[
    'Blurred vision',
    'Floaters',
    'Eye pain',
    'Light sensitivity',
    'Redness',
    'Headache',
  ];

  // Home banner
  static const String bannerTitle = 'Check your retina with AI';
  static const String bannerDesc =
      'Upload a photo and get your results in seconds.';
  static const String bannerButton = 'Start Scan';
}