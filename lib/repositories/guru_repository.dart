import '../models/guru_dashboard.dart';
import '../models/models.dart';

/// Kontrak data role Guru.
///
/// Saat ini diimplementasikan oleh `MockGuruRepository`. Implementasi API
/// cukup meng-`implements` kelas ini lalu dikirim ke `LmsApp(guruRepository:)`;
/// layar dan controller tidak perlu diubah.
///
/// Error yang ingin ditampilkan ke pengguna harus dilempar sebagai
/// `DataException` dengan pesan berbahasa Indonesia.
abstract class GuruRepository {
  Future<GuruDashboardData> fetchDashboard();

  /// Hari aktif sekolah minggu ini (untuk pemilih hari di layar Jadwal).
  Future<List<WeekDay>> fetchWeekDays();

  Future<List<ScheduleItem>> fetchScheduleForDay(String dayKey);

  Future<List<ClassItem>> fetchClasses();

  Future<List<StudentItem>> fetchStudentsByClass(String className);

  /// Form absensi untuk hari ini. Parameter kosong = kelas/mapel default guru.
  Future<AttendanceDraft> fetchAttendanceDraft({
    String? className,
    String? subject,
  });

  /// [statuses] dipetakan per NIS siswa. Mengembalikan entri riwayat baru.
  Future<AttendanceHistoryItem> saveAttendance({
    required String className,
    required String subject,
    required String dateLabel,
    required Map<String, AttendanceStatus> statuses,
  });

  Future<AttendanceHistoryBundle> fetchAttendanceHistory({String? month});
}
