import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/kepsek_models.dart';
import '../repositories/kepsek_repository.dart';
import 'load_state.dart';

export 'load_state.dart';

class KepsekController extends ChangeNotifier {
  KepsekController({required this.repository});

  final KepsekRepository repository;

  String? _kepsekUserId;

  LoadState dashboardState = LoadState.idle;
  LoadState attendanceState = LoadState.idle;
  LoadState scheduleState = LoadState.idle;
  LoadState reportState = LoadState.idle;
  LoadState approvalState = LoadState.idle;
  LoadState announcementState = LoadState.idle;

  String? dashboardError;
  String? attendanceError;
  String? scheduleError;
  String? reportError;
  String? approvalError;
  String? announcementError;

  KepsekDashboardData? dashboard;
  KepsekAttendanceMonitoring? attendanceMonitoring;
  KepsekScheduleMonitoring? scheduleMonitoring;
  KepsekAcademicReport? academicReport;
  List<ScheduleApprovalItem> approvals = const [];
  List<SchoolAnnouncement> announcements = const [];
  bool isUpdatingApproval = false;
  bool isSavingAnnouncement = false;

  void bindKepsek(String kepsekUserId) {
    if (_kepsekUserId == kepsekUserId) return;
    _kepsekUserId = kepsekUserId;
    dashboard = null;
    attendanceMonitoring = null;
    scheduleMonitoring = null;
    academicReport = null;
    approvals = const [];
    announcements = const [];
  }

  String get _requireId {
    final id = _kepsekUserId;
    if (id == null || id.isEmpty) {
      throw const DataException(
        'Sesi Kepala Sekolah tidak valid.',
        code: 'unauthenticated',
      );
    }
    return id;
  }

  Future<void> loadDashboard() async {
    dashboardState = LoadState.loading;
    dashboardError = null;
    notifyListeners();
    try {
      dashboard = await repository.fetchDashboard(kepsekUserId: _requireId);
      dashboardState = LoadState.ready;
    } on DataException catch (error) {
      dashboardError = error.message;
      dashboardState = LoadState.error;
    } catch (_) {
      dashboardError = 'Gagal memuat dashboard Kepala Sekolah.';
      dashboardState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadAttendanceMonitoring({String? month}) async {
    attendanceState = LoadState.loading;
    attendanceError = null;
    notifyListeners();
    try {
      attendanceMonitoring = await repository.fetchAttendanceMonitoring(
        kepsekUserId: _requireId,
        month: month,
      );
      attendanceState = LoadState.ready;
    } on DataException catch (error) {
      attendanceError = error.message;
      attendanceState = LoadState.error;
    } catch (_) {
      attendanceError = 'Gagal memuat monitoring kehadiran.';
      attendanceState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadScheduleMonitoring({
    String? classFilter,
    String? teacherFilter,
  }) async {
    scheduleState = LoadState.loading;
    scheduleError = null;
    notifyListeners();
    try {
      scheduleMonitoring = await repository.fetchScheduleMonitoring(
        kepsekUserId: _requireId,
        classFilter: classFilter ?? scheduleMonitoring?.selectedClass,
        teacherFilter: teacherFilter ?? scheduleMonitoring?.selectedTeacher,
      );
      scheduleState = LoadState.ready;
    } on DataException catch (error) {
      scheduleError = error.message;
      scheduleState = LoadState.error;
    } catch (_) {
      scheduleError = 'Gagal memuat monitoring jadwal.';
      scheduleState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadAcademicReport() async {
    reportState = LoadState.loading;
    reportError = null;
    notifyListeners();
    try {
      academicReport =
          await repository.fetchAcademicReport(kepsekUserId: _requireId);
      reportState = LoadState.ready;
    } on DataException catch (error) {
      reportError = error.message;
      reportState = LoadState.error;
    } catch (_) {
      reportError = 'Gagal memuat laporan akademik.';
      reportState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadApprovals() async {
    approvalState = LoadState.loading;
    approvalError = null;
    notifyListeners();
    try {
      approvals =
          await repository.fetchScheduleApprovals(kepsekUserId: _requireId);
      approvalState =
          approvals.isEmpty ? LoadState.empty : LoadState.ready;
    } on DataException catch (error) {
      approvalError = error.message;
      approvalState = LoadState.error;
    } catch (_) {
      approvalError = 'Gagal memuat persetujuan jadwal.';
      approvalState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> updateApproval({
    required String approvalId,
    required ScheduleApprovalStatus status,
  }) async {
    isUpdatingApproval = true;
    approvalError = null;
    notifyListeners();
    try {
      await repository.updateApprovalStatus(
        kepsekUserId: _requireId,
        approvalId: approvalId,
        status: status,
      );
      await loadApprovals();
      await loadDashboard();
    } on DataException catch (error) {
      approvalError = error.message;
      rethrow;
    } catch (_) {
      approvalError = 'Gagal memperbarui status persetujuan.';
      throw DataException(approvalError!, code: 'unknown');
    } finally {
      isUpdatingApproval = false;
      notifyListeners();
    }
  }

  Future<void> loadAnnouncements() async {
    announcementState = LoadState.loading;
    announcementError = null;
    notifyListeners();
    try {
      announcements =
          await repository.fetchAnnouncements(kepsekUserId: _requireId);
      announcementState =
          announcements.isEmpty ? LoadState.empty : LoadState.ready;
    } on DataException catch (error) {
      announcementError = error.message;
      announcementState = LoadState.error;
    } catch (_) {
      announcementError = 'Gagal memuat pengumuman.';
      announcementState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> createAnnouncement({
    required String title,
    required String body,
  }) async {
    isSavingAnnouncement = true;
    announcementError = null;
    notifyListeners();
    try {
      await repository.createAnnouncement(
        kepsekUserId: _requireId,
        title: title,
        body: body,
      );
      await loadAnnouncements();
    } on DataException catch (error) {
      announcementError = error.message;
      rethrow;
    } catch (_) {
      announcementError = 'Gagal membuat pengumuman.';
      throw DataException(announcementError!, code: 'unknown');
    } finally {
      isSavingAnnouncement = false;
      notifyListeners();
    }
  }
}

class KepsekScope extends InheritedNotifier<KepsekController> {
  const KepsekScope({
    super.key,
    required KepsekController controller,
    required super.child,
  }) : super(notifier: controller);

  static KepsekController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KepsekScope>();
    assert(scope != null, 'KepsekScope tidak ditemukan');
    return scope!.notifier!;
  }
}
