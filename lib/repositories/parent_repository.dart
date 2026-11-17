import '../models/parent_models.dart';

/// Kontrak data role Orang Tua.
///
/// Semua method wajib menerima `parentUserId` dan implementasi wajib
/// menolak `childId` yang tidak terhubung ke akun tersebut. Pemeriksaan ini
/// harus tetap dilakukan di backend; pengecekan di aplikasi hanya lapis kedua.
///
/// `childId` null berarti anak pertama yang terhubung. Jika akun tidak punya
/// anak terhubung, lempar `DataException` dengan kode `no_linked_child`.
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
