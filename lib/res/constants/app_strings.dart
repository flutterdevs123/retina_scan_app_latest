/// All user-facing static texts live here (easy to edit / localize later).
class AppStrings {
  AppStrings._();

  // ---------------------------------------------------------------------------
  // General
  // ---------------------------------------------------------------------------
  static const String appName = 'Retina Scan';
  static const String notSet = 'Not set';
  static const String viewAll = 'View All';

  // ---------------------------------------------------------------------------
  // Roles
  // ---------------------------------------------------------------------------
  static const String roleDoctor = 'Doctor';
  static const String rolePatient = 'Patient';
  static const String roleLabel = 'I am a';

  // ---------------------------------------------------------------------------
  // Splash
  // ---------------------------------------------------------------------------
  static const String splashTagline =
      'Smart retina screening,\nright at your fingertips';
  static const String splashLoading = 'Preparing your secure scan...';

  // ---------------------------------------------------------------------------
  // Common buttons
  // ---------------------------------------------------------------------------
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';

  // ---------------------------------------------------------------------------
  // Onboarding
  // ---------------------------------------------------------------------------
  static const String onboardingTitle1 = 'Scan Your Retina\nIn Seconds';
  static const String onboardingDesc1 =
      'Use your phone camera to capture a clear retina image quickly and '
      'easily, with simple on-screen guidance.';

  static const String onboardingTitle2 = 'Smart Analysis\nYou Can Trust';
  static const String onboardingDesc2 =
      'Advanced analysis highlights early signs of eye conditions and '
      'gives you clear, easy to understand results.';

  static const String onboardingTitle3 = 'Private And\nSecure Records';
  static const String onboardingDesc3 =
      'Your scans are protected and stored safely. Track your eye health '
      'over time and share reports with your doctor.';

  // ---------------------------------------------------------------------------
  // Auth: shared field labels and hints
  // ---------------------------------------------------------------------------
  static const String emailLabel = 'Email';
  static const String emailHint = 'you@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String newPasswordHint = 'Create a strong password';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Enter your full name';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle =
      'Log in to continue your eye health journey';
  static const String forgotPassword = 'Forgot Password?';
  static const String logIn = 'Log In';
  static const String noAccount = "Don't have an account?";
  static const String signUp = 'Sign Up';

  // ---------------------------------------------------------------------------
  // Sign up
  // ---------------------------------------------------------------------------
  static const String signupTitle = 'Create Account';
  static const String signupSubtitle =
      'Sign up to start scanning and tracking your eye health';
  static const String createAccount = 'Create Account';
  static const String haveAccount = 'Already have an account?';

  // ---------------------------------------------------------------------------
  // Verify email
  // ---------------------------------------------------------------------------
  static const String verifyTitle = 'Verify Your Email';
  static const String verifySubtitle =
      'We have sent a verification link to your inbox. Please open it to '
      'verify your email address.';
  static const String verifySpamTip =
      "Can't find the email in your inbox? Please check your spam or junk "
      'folder.';
  static const String resendEmail = 'Resend Email';
  static const String verifyResent = 'Verification email sent again';
  static const String alreadyVerified = 'Already verified?';

  /// Button label while the resend cooldown is running.
  static String resendIn(int seconds) => 'Resend in ${seconds}s';

  // ---------------------------------------------------------------------------
  // Forgot password
  // ---------------------------------------------------------------------------
  static const String forgotTitle = 'Forgot Password?';
  static const String forgotSubtitle =
      "Enter your email and we'll send you a link to reset your password.";
  static const String sendResetLink = 'Send Reset Link';
  static const String rememberPassword = 'Remember your password?';
  static const String resetSentTitle = 'Check Your Email';
  static const String resetSentDesc =
      'We have sent a password reset link to the email address below.';
  static const String resetResent = 'Reset link sent again';
  static const String backToLogin = 'Back to Log In';
  static const String resendLink = 'Resend Link';
  static const String useDifferentEmail = 'Use a different email';

  // ---------------------------------------------------------------------------
  // Dashboard: navigation and shared
  // ---------------------------------------------------------------------------
  static const String navHome = 'Home';
  static const String navRequests = 'Requests';
  static const String navReports = 'Reports';
  static const String navPatients = 'Patients';
  static const String navProfile = 'Profile';
  static const String navNewRequest = 'New Request';
  static const String navMyReports = 'My Reports';

  static const String welcomeBack = 'Welcome back,';
  static const String logOut = 'Log Out';

  // Stats
  static const String statPendingReviews = 'To Review';
  static const String statPending = 'Pending';
  static const String statAccepted = 'Accepted';
  static const String statRejected = 'Rejected';
  static const String statMyPatients = 'Patients';
  static const String statTotalReports = 'Total';
  static const String statNotReviewed = 'Unreviewed';

  // Report status and filters
  static const String statusPending = 'Pending';
  static const String statusAccepted = 'Accepted';
  static const String statusRejected = 'Rejected';
  static const String filterAll = 'All';

  // Empty states
  static const String emptyReportsTitle = 'No reports yet';
  static const String emptyReportsMsg =
      'Reports will appear here once they are available.';
  static const String emptyRequestsTitle = 'No pending requests';
  static const String emptyRequestsMsg =
      'New review requests from patients will appear here.';

  // ---------------------------------------------------------------------------
  // Doctor
  // ---------------------------------------------------------------------------
  static const String recentRequests = 'Recent Review Requests';
  static const String requestsTitle = 'Review Requests';
  static const String requestsSubtitle = 'Reports waiting for your decision';
  static const String doctorReportsTitle = 'Reviewed Reports';
  static const String doctorReportsSubtitle = 'Accepted and rejected reports';

  static const String patientsTitle = 'Patients';
  static const String patientsSubtitle = 'Search any patient by name or ID';
  static const String searchPatientsHint = 'Search patient by name or ID';
  static const String myPatientFiles = 'My Patient Files';
  static const String searchResults = 'Search Results';
  static const String noPatientsTitle = 'No patients found';
  static const String noPatientsMsg = 'Try a different name or ID.';

  static const String patientHistoryTitle = 'Patient History';
  static const String medicalHistory = 'Medical History';
  static const String retinaScanReport = 'Retina Scan Report';
  static const String noHistoryTitle = 'No history with you yet';
  static const String noHistoryMsg =
      'Reports this patient sends to you will be listed here.';
  static const String patientNotFound = 'Patient not found';
  static const String patientNotFoundMsg =
      'This patient does not exist or was removed.';

  /// Number of reports shown on a patient tile.
  static String reportsCount(int count) {
    if (count == 0) return 'No reports with you yet';
    return count == 1 ? '1 report' : '$count reports';
  }

  // ---------------------------------------------------------------------------
  // Patient
  // ---------------------------------------------------------------------------
  static const String recentReports = 'Recent Reports';
  static const String startNewRequest = 'Request a Review';
  static const String startNewRequestDesc =
      'Send your retina scan to a doctor';
  static const String patientReportsTitle = 'My Reports';
  static const String patientReportsSubtitle =
      'Track the review status of your scans';

  static const String newRequestTitle = 'New Request';
  static const String findDoctorSubtitle =
      'Find a doctor by name, ID or specialty';
  static const String searchDoctorsHint = 'Search doctor by name or ID';
  static const String availableDoctors = 'Available Doctors';
  static const String noDoctorsTitle = 'No doctors found';
  static const String noDoctorsMsg = 'Try a different name, ID or specialty.';

  static const String requestReviewTitle = 'Request a Review';
  static const String sendingTo = 'Sending to';
  static const String scanAttached = 'Retina scan attached (demo)';
  static const String symptomsLabel = 'Symptoms / Notes';
  static const String symptomsHint = 'Describe your symptoms or concerns';
  static const String sendRequest = 'Send Request';
  static const String doctorNotFound = 'Doctor not found';
  static const String doctorNotFoundMsg =
      'This doctor does not exist or was removed.';

  // ---------------------------------------------------------------------------
  // Report detail
  // ---------------------------------------------------------------------------
  static const String reportDetailsTitle = 'Report Details';
  static const String reportNotFound = 'Report not found';
  static const String reportNotFoundMsg =
      'This report does not exist or was removed.';
  static const String scanPlaceholder = 'Retina scan image (demo)';
  static const String labelPatient = 'Patient';
  static const String labelDoctor = 'Doctor';
  static const String labelSubmitted = 'Submitted';
  static const String labelReviewed = 'Reviewed';
  static const String symptomsTitle = 'Symptoms';
  static const String doctorNoteTitle = "Doctor's Note";
  static const String waitingReview =
      'Waiting for the doctor to review this report. You will get a '
      'notification as soon as a decision is made.';
  static const String viewPatientHistory = 'View Patient History';
  static const String noteLabel = 'Your Note';
  static const String noteHint = 'Add a note or reason for the patient';
  static const String accept = 'Accept';
  static const String reject = 'Reject';

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------
  static const String notificationsTitle = 'Notifications';
  static const String markAllRead = 'Mark all read';
  static const String emptyNotifTitle = 'No notifications';
  static const String emptyNotifMsg = 'You are all caught up.';
  static const String notifNewRequestTitle = 'New review request';
  static const String notifAcceptedTitle = 'Report accepted';
  static const String notifRejectedTitle = 'Report rejected';

  static String notifNewRequestBody(String patient) =>
      '$patient sent a retina report for your review.';
  static String notifAcceptedBody(String doctor) =>
      '$doctor accepted your report.';
  static String notifRejectedBody(String doctor) =>
      '$doctor rejected your report. Open it to read the reason.';

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------
  static const String profileTitle = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String saveChanges = 'Save Changes';
  static const String labelId = 'User ID';
  static const String labelEmail = 'Email';
  static const String labelPhone = 'Phone';
  static const String phoneLabel = 'Phone Number';
  static const String phoneHint = '+92 300 1234567';
  static const String specialtyLabel = 'Specialty';
  static const String specialtyHint = 'e.g. Retina Specialist';
  static const String ageLabel = 'Age';
  static const String ageHint = 'Enter your age';

  static String ageYears(String age) => '$age years';

  // ---------------------------------------------------------------------------
  // Dates
  // ---------------------------------------------------------------------------
  static const String justNow = 'Just now';
  static String minutesAgo(int minutes) => '${minutes}m ago';
  static String hoursAgo(int hours) => '${hours}h ago';
  static String daysAgo(int days) => '${days}d ago';

  // ---------------------------------------------------------------------------
  // Validation errors
  // ---------------------------------------------------------------------------
  static const String errNameRequired = 'Please enter your full name';
  static const String errNameShort = 'Name must be at least 3 characters';
  static const String errEmailRequired = 'Please enter your email';
  static const String errEmailInvalid = 'Please enter a valid email address';
  static const String errPasswordRequired = 'Please enter your password';
  static const String errPasswordShort =
      'Password must be at least 8 characters';
  static const String errPasswordWeak =
      'Password must contain at least one letter and one number';
  static const String errConfirmRequired = 'Please confirm your password';
  static const String errPasswordMismatch = 'Passwords do not match';
  static const String errInvalidCredentials =
      'Incorrect email or password. Please try again.';
  static const String errPhoneRequired = 'Please enter your phone number';
  static const String errPhoneInvalid =
      'Enter a valid phone number (10 to 15 digits)';
  static const String errAgeRequired = 'Please enter your age';
  static const String errAgeInvalid = 'Enter a valid age between 1 and 120';
  static const String errSpecialtyRequired = 'Please enter your specialty';
  static const String errSpecialtyShort =
      'Specialty must be at least 3 characters';
  static const String errSymptomsRequired = 'Please describe your symptoms';
  static const String errSymptomsShort =
      'Please write at least 10 characters';
  static const String errReasonRequired = 'Please add a reason for rejecting';
}