import 'dart:async';

import 'package:get/get.dart';
import 'package:retina_scan_app/models/notification_model.dart';
import 'package:retina_scan_app/models/report_model.dart';
import 'package:retina_scan_app/models/report_status.dart';
import 'package:retina_scan_app/models/user_model.dart';
import 'package:retina_scan_app/models/user_role.dart';
import 'package:retina_scan_app/res/constants/app_strings.dart';
import 'package:retina_scan_app/res/services/api_client.dart';
import 'package:retina_scan_app/res/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache of the server data (reports and doctors) for the logged in user.
///
/// - Loads data right after login and clears it on logout.
/// - Refreshes reports every 30 seconds so new requests / decisions appear.
/// - Controllers only read from here; only this class calls the API.
class DataService extends GetxService {
  static const Duration _syncEvery = Duration(seconds: 30);

  final ApiClient _api = Get.find<ApiClient>();
  final AuthService _auth = Get.find<AuthService>();

  final RxList<ReportModel> reports = <ReportModel>[].obs;
  final RxList<UserModel> doctors = <UserModel>[].obs;

  /// IDs of notifications the user has already opened.
  final RxList<String> _readIds = <String>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    ever<UserModel?>(_auth.currentUser, _onUserChanged);
  }

  void _onUserChanged(UserModel? user) {
    _timer?.cancel();
    if (user == null) {
      reports.clear();
      doctors.clear();
      _readIds.clear();
      return;
    }
    _loadReadIds(user.id);
    refreshAll();
    _timer = Timer.periodic(_syncEvery, (_) => refreshReports());
  }

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  /// Loads reports (and the doctor list for patients).
  Future<void> refreshAll() async {
    await Future.wait(<Future<void>>[
      refreshReports(),
      if (_auth.currentUser.value?.role == UserRole.patient) refreshDoctors(),
    ]);
  }

  /// GET /scans (the server returns only what this user may see).
  Future<void> refreshReports() async {
    if (!_auth.isLoggedIn) return;
    try {
      final dynamic res = await _api.get(
        '/api/v1/scans',
        query: <String, String>{'limit': '200'},
      );
      final List<ReportModel> items = ApiClient.listFrom(
        res,
        <String>['scans', 'items', 'data', 'results'],
      ).whereType<Map>().map((Map m) {
        return ReportModel.fromJson(Map<String, dynamic>.from(m));
      }).toList();
      reports.assignAll(items);
    } on ApiException {
      // Keep showing the old data when a refresh fails.
    }
  }

  /// GET /doctors.
  Future<void> refreshDoctors() async {
    try {
      final dynamic res = await _api.get('/api/v1/doctors');
      final List<UserModel> items = ApiClient.listFrom(
        res,
        <String>['doctors', 'items', 'data', 'results'],
      ).whereType<Map>().map((Map m) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(m),
          fallbackRole: UserRole.doctor,
        );
      }).toList();
      doctors.assignAll(items);
    } on ApiException {
      // Keep the old list.
    }
  }

  /// GET /scans/{id}: full details of one report.
  Future<ReportModel?> fetchReport(String reportId) async {
    final int id = int.tryParse(reportId.split('-').last) ?? 0;
    try {
      final dynamic res = await _api.get('/api/v1/scans/$id');
      if (res is! Map) return null;
      final ReportModel report =
      ReportModel.fromJson(Map<String, dynamic>.from(res));
      upsertReport(report);
      return report;
    } on ApiException {
      return null;
    }
  }

  /// Adds a report or replaces the one with the same ID.
  void upsertReport(ReportModel report) {
    final int index = reports.indexWhere((ReportModel r) => r.id == report.id);
    if (index == -1) {
      reports.insert(0, report);
    } else {
      reports[index] = report;
    }
  }

  // ---------------------------------------------------------------------------
  // Actions (throw ApiException on failure)
  // ---------------------------------------------------------------------------

  /// Patient sends a draft scan to a doctor.
  Future<void> submitScan({
    required int scanId,
    required UserModel doctor,
    required String notes,
  }) async {
    await _api.post(
      '/api/v1/scans/$scanId/submit',
      body: <String, dynamic>{'doctor_id': doctor.apiId, 'notes': notes},
    );
    await fetchReport('RPT-$scanId');
  }

  /// Doctor approves or rejects a report.
  Future<void> reviewReport({
    required String reportId,
    required bool accepted,
    String note = '',
    String? doctorGrade,
  }) async {
    final int id = int.tryParse(reportId.split('-').last) ?? 0;
    await _api.post(
      '/api/v1/scans/$id/review',
      body: <String, dynamic>{
        'action': accepted ? 'approved' : 'rejected',
        'comment': note.trim(),
        if (doctorGrade != null) 'doctor_grade': doctorGrade,
      },
    );
    await fetchReport(reportId);
  }

  /// Deletes a scan that was never sent.
  Future<void> deleteDraft(String reportId) async {
    final int id = int.tryParse(reportId.split('-').last) ?? 0;
    await _api.delete('/api/v1/scans/$id');
    reports.removeWhere((ReportModel r) => r.id == reportId);
  }

  // ---------------------------------------------------------------------------
  // Queries used by controllers
  // ---------------------------------------------------------------------------

  ReportModel? reportById(String id) =>
      reports.firstWhereOrNull((ReportModel r) => r.id == id);

  /// Reports sent to a doctor (drafts are never included), newest first.
  List<ReportModel> reportsOfDoctor(String doctorId) => _newestFirst(
    reports.where(
          (ReportModel r) =>
      r.doctorId == doctorId && r.status != ReportStatus.draft,
    ),
  );

  /// All scans of a patient (drafts included), newest first.
  List<ReportModel> reportsOfPatient(String patientId) =>
      _newestFirst(reports.where((ReportModel r) => r.patientId == patientId));

  /// Medical history file: every report of [patientId] sent to [doctorId].
  List<ReportModel> historyOf(String patientId, String doctorId) {
    return _newestFirst(
      reports.where(
            (ReportModel r) =>
        r.patientId == patientId &&
            r.doctorId == doctorId &&
            r.status != ReportStatus.draft,
      ),
    );
  }

  /// Patients who sent at least one report to [doctorId].
  List<UserModel> patientsOfDoctor(String doctorId) {
    final Set<String> seen = <String>{};
    final List<UserModel> result = <UserModel>[];
    for (final ReportModel r in reportsOfDoctor(doctorId)) {
      if (r.patientId.isEmpty || !seen.add(r.patientId)) continue;
      result.add(UserModel(
        id: r.patientId,
        name: r.patientName,
        email: '',
        role: UserRole.patient,
      ));
    }
    return result;
  }

  /// Finds a doctor or patient by app ID.
  UserModel? userById(String id) {
    final UserModel? me = _auth.currentUser.value;
    if (me?.id == id) return me;
    return doctors.firstWhereOrNull((UserModel u) => u.id == id) ??
        patientsOfDoctor(me?.id ?? '')
            .firstWhereOrNull((UserModel u) => u.id == id);
  }

  /// Search by name, ID or specialty (an empty query returns everyone).
  List<UserModel> searchUsers(UserRole role, String query) {
    final String q = query.trim().toLowerCase();
    final List<UserModel> source = role == UserRole.doctor
        ? doctors.toList()
        : patientsOfDoctor(_auth.currentUser.value?.id ?? '');
    if (q.isEmpty) return source;
    return source.where((UserModel u) {
      return u.name.toLowerCase().contains(q) ||
          u.id.toLowerCase().contains(q) ||
          u.apiId.toString() == q ||
          u.specialty.toLowerCase().contains(q);
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Notifications (the server has no endpoint, so they come from scan status)
  // ---------------------------------------------------------------------------

  List<NotificationModel> notificationsOf(String userId) {
    final UserModel? me = _auth.currentUser.value;
    if (me == null || me.id != userId) return const <NotificationModel>[];

    final List<NotificationModel> items = <NotificationModel>[];

    if (me.role == UserRole.doctor) {
      for (final ReportModel r in reportsOfDoctor(userId)) {
        if (r.status != ReportStatus.pending) continue;
        items.add(_notification(
          id: 'req-${r.id}',
          userId: userId,
          type: NotificationType.newRequest,
          title: AppStrings.notifNewRequestTitle,
          body: AppStrings.notifNewRequestBody(r.patientName),
          date: r.sortDate,
          reportId: r.id,
        ));
      }
    } else {
      for (final ReportModel r in reportsOfPatient(userId)) {
        final bool accepted = r.status == ReportStatus.accepted;
        if (!accepted && r.status != ReportStatus.rejected) continue;
        items.add(_notification(
          id: 'rev-${r.id}-${r.status.name}',
          userId: userId,
          type: accepted ? NotificationType.accepted : NotificationType.rejected,
          title: accepted
              ? AppStrings.notifAcceptedTitle
              : AppStrings.notifRejectedTitle,
          body: accepted
              ? AppStrings.notifAcceptedBody(r.doctorName)
              : AppStrings.notifRejectedBody(r.doctorName),
          date: r.reviewedAt ?? r.sortDate,
          reportId: r.id,
        ));
      }
    }

    items.sort((NotificationModel a, NotificationModel b) =>
        b.createdAt.compareTo(a.createdAt));
    return items;
  }

  int unreadCount(String userId) => notificationsOf(userId)
      .where((NotificationModel n) => !n.isRead)
      .length;

  void markRead(String notificationId) {
    if (_readIds.contains(notificationId)) return;
    _readIds.add(notificationId);
    _saveReadIds();
  }

  void markAllRead(String userId) {
    for (final NotificationModel n in notificationsOf(userId)) {
      if (!n.isRead) _readIds.add(n.id);
    }
    _saveReadIds();
  }

  NotificationModel _notification({
    required String id,
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime date,
    required String reportId,
  }) {
    return NotificationModel(
      id: id,
      userId: userId,
      type: type,
      title: title,
      body: body,
      createdAt: date,
      reportId: reportId,
      isRead: _readIds.contains(id),
    );
  }

  Future<void> _loadReadIds(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _readIds.assignAll(prefs.getStringList('read_notifs_$userId') ?? <String>[]);
  }

  Future<void> _saveReadIds() async {
    final String? userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('read_notifs_$userId', _readIds.toList());
  }

  List<ReportModel> _newestFirst(Iterable<ReportModel> items) {
    final List<ReportModel> list = items.toList();
    list.sort((ReportModel a, ReportModel b) => b.sortDate.compareTo(a.sortDate));
    return list;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}