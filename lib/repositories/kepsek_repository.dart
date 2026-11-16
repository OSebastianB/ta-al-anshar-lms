import '../models/kepsek_models.dart';

/// Kontrak data Kepala Sekolah (monitoring & laporan).
/// Tidak mencakup generate jadwal otomatis atau pengelolaan database.
abstract class KepsekRepository {
  Future<KepsekDashboardData> fetchDashboard({required String kepsekUserId});

  Future<KepsekAttendanceMonitoring> fetchAttendanceMonitoring({
    required String kepsekUserId,
    String? month,
  });

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
