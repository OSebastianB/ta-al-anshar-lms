import '../models/kepsek_models.dart';

/// Kontrak data role Kepala Sekolah (monitoring, laporan, persetujuan jadwal,
/// pengumuman).
///
/// Tidak mencakup pembuatan jadwal otomatis maupun pengelolaan master data;
/// keduanya ada di aplikasi web Admin. Semua method menerima `kepsekUserId`
/// supaya backend bisa memverifikasi peran pemanggil.
abstract class KepsekRepository {
  Future<KepsekDashboardData> fetchDashboard({required String kepsekUserId});

  /// [month] null = bulan berjalan.
  Future<KepsekAttendanceMonitoring> fetchAttendanceMonitoring({
    required String kepsekUserId,
    String? month,
  });

  /// Filter null = semua kelas / semua guru.
  Future<KepsekScheduleMonitoring> fetchScheduleMonitoring({
    required String kepsekUserId,
    String? classFilter,
    String? teacherFilter,
  });

  Future<KepsekAcademicReport> fetchAcademicReport({
    required String kepsekUserId,
  });

  Future<List<ScheduleApprovalItem>> fetchScheduleApprovals({
    required String kepsekUserId,
  });

  Future<ScheduleApprovalItem> updateApprovalStatus({
    required String kepsekUserId,
    required String approvalId,
    required ScheduleApprovalStatus status,
  });

  Future<List<SchoolAnnouncement>> fetchAnnouncements({
    required String kepsekUserId,
  });

  Future<SchoolAnnouncement> createAnnouncement({
    required String kepsekUserId,
    required String title,
    required String body,
  });
}
