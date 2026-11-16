import '../models/parent_models.dart';

/// Kontrak data Orang Tua. Semua akses harus menyertakan parentUserId
/// agar hanya anak yang terhubung akun yang dapat diambil.
abstract class ParentRepository {
  Future<List<LinkedChild>> fetchLinkedChildren({
    required String parentUserId,
  });

  Future<ParentDashboardData> fetchDashboard({
    required String parentUserId,
    String? childId,
  });

  Future<ParentAttendanceData> fetchAttendance({
    required String parentUserId,
    String? childId,
    String? month,
  });

  Future<ParentScheduleData> fetchSchedule({
    required String parentUserId,
    String? childId,
    String? dayKey,
  });
}
