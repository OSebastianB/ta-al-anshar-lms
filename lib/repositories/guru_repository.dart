import '../models/guru_dashboard.dart';
import '../models/models.dart';

abstract class GuruRepository {
  Future<GuruDashboardData> fetchDashboard();

  Future<List<WeekDay>> fetchWeekDays();

  Future<List<ScheduleItem>> fetchScheduleForDay(String dayKey);

  Future<List<ClassItem>> fetchClasses();

  Future<List<StudentItem>> fetchStudentsByClass(String className);

  Future<AttendanceDraft> fetchAttendanceDraft({
    String? className,
    String? subject,
  });

  Future<AttendanceHistoryItem> saveAttendance({
    required String className,
    required String subject,
    required String dateLabel,
    required Map<String, AttendanceStatus> statuses,
  });

  Future<AttendanceHistoryBundle> fetchAttendanceHistory({String? month});
}
