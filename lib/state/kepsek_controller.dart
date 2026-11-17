import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/kepsek_models.dart';
import '../repositories/kepsek_repository.dart';
import 'async_runner.dart';
import 'load_state.dart';

export 'load_state.dart';

/// State layar role Kepala Sekolah: monitoring, laporan, persetujuan jadwal,
/// dan pengumuman.
///
/// Semua request membawa `kepsekUserId` dari sesi (lihat [bindKepsek]) agar
/// backend bisa memverifikasi bahwa pemanggil memang Kepala Sekolah.
class KepsekController extends ChangeNotifier with AsyncRunner {
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

  /// Mengikat controller ke akun yang login. Jika akun berganti, semua data
  /// sebelumnya dibuang.
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

  // ---------------------------------------------------------------------------
  // Dashboard & monitoring
  // ---------------------------------------------------------------------------

  Future<void> loadDashboard() => runLoad(
        update: (state, error) {
          dashboardState = state;
          dashboardError = error;
        },
        fallbackError: 'Gagal memuat dashboard Kepala Sekolah.',
        task: () async {
          dashboard = await repository.fetchDashboard(kepsekUserId: _requireId);
          return LoadState.ready;
        },
      );

  Future<void> loadAttendanceMonitoring({String? month}) => runLoad(
        update: (state, error) {
          attendanceState = state;
          attendanceError = error;
        },
        fallbackError: 'Gagal memuat monitoring kehadiran.',
        task: () async {
          attendanceMonitoring = await repository.fetchAttendanceMonitoring(
            kepsekUserId: _requireId,
            month: month,
          );
          return LoadState.ready;
        },
      );

  /// Filter yang tidak diisi memakai filter yang sedang aktif.
  Future<void> loadScheduleMonitoring({
    String? classFilter,
    String? teacherFilter,
  }) =>
      runLoad(
        update: (state, error) {
          scheduleState = state;
          scheduleError = error;
        },
        fallbackError: 'Gagal memuat monitoring jadwal.',
        task: () async {
          scheduleMonitoring = await repository.fetchScheduleMonitoring(
            kepsekUserId: _requireId,
            classFilter: classFilter ?? scheduleMonitoring?.selectedClass,
            teacherFilter:
                teacherFilter ?? scheduleMonitoring?.selectedTeacher,
          );
          return LoadState.ready;
        },
      );

  Future<void> loadAcademicReport() => runLoad(
        update: (state, error) {
          reportState = state;
          reportError = error;
        },
        fallbackError: 'Gagal memuat laporan akademik.',
        task: () async {
          academicReport =
              await repository.fetchAcademicReport(kepsekUserId: _requireId);
          return LoadState.ready;
        },
      );

  // ---------------------------------------------------------------------------
  // Persetujuan jadwal
  // ---------------------------------------------------------------------------

  Future<void> loadApprovals() => runLoad(
        update: (state, error) {
          approvalState = state;
          approvalError = error;
        },
        fallbackError: 'Gagal memuat persetujuan jadwal.',
        task: () async {
          approvals =
              await repository.fetchScheduleApprovals(kepsekUserId: _requireId);
          return stateForList(approvals);
        },
      );

  /// Setujui/tolak jadwal, lalu muat ulang daftar dan ringkasan dashboard
  /// karena jumlah "menunggu persetujuan" ikut berubah.
  Future<void> updateApproval({
    required String approvalId,
    required ScheduleApprovalStatus status,
  }) {
    return runAction(
      setBusy: (busy) => isUpdatingApproval = busy,
      setError: (error) => approvalError = error,
      fallbackError: 'Gagal memperbarui status persetujuan.',
      task: () async {
        await repository.updateApprovalStatus(
          kepsekUserId: _requireId,
          approvalId: approvalId,
          status: status,
        );
        await loadApprovals();
        await loadDashboard();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Pengumuman
  // ---------------------------------------------------------------------------

  Future<void> loadAnnouncements() => runLoad(
        update: (state, error) {
          announcementState = state;
          announcementError = error;
        },
        fallbackError: 'Gagal memuat pengumuman.',
        task: () async {
          announcements =
              await repository.fetchAnnouncements(kepsekUserId: _requireId);
          return stateForList(announcements);
        },
      );

  Future<void> createAnnouncement({
    required String title,
    required String body,
  }) {
    return runAction(
      setBusy: (busy) => isSavingAnnouncement = busy,
      setError: (error) => announcementError = error,
      fallbackError: 'Gagal membuat pengumuman.',
      task: () async {
        await repository.createAnnouncement(
          kepsekUserId: _requireId,
          title: title,
          body: body,
        );
        await loadAnnouncements();
      },
    );
  }
}

/// Menyediakan [KepsekController] ke semua layar di bawah `KepsekShell`.
///
/// Halaman yang di-push dengan `Navigator` berada di luar shell, jadi harus
/// dibungkus ulang dengan [KepsekScope] (lihat `KepsekProfileScreen`).
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
