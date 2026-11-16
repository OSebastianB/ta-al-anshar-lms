import '../data/dummy_data.dart';

export '../data/dummy_data.dart'
    show
        ChartPoint,
        ClassAttendanceStat,
        ScheduleApprovalItem,
        ScheduleApprovalStatus,
        ScheduleApprovalStatusStyle,
        SchoolAnnouncement,
        SchoolScheduleItem,
        TeacherAttendanceStat;

class KepsekDashboardData {
  const KepsekDashboardData({
    required this.dateLabel,
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalClasses,
    required this.studentPresencePercent,
    required this.teacherPresencePercent,
    required this.pendingApprovals,
    required this.activities,
    required this.todaySchedule,
    required this.notices,
  });

  final String dateLabel;
  final int totalStudents;
  final int totalTeachers;
  final int totalClasses;
  final double studentPresencePercent;
  final double teacherPresencePercent;
  final int pendingApprovals;
  final List<AnnouncementItem> activities;
  final List<SchoolScheduleItem> todaySchedule;
  final List<AppNotice> notices;
}

class KepsekAttendanceMonitoring {
  const KepsekAttendanceMonitoring({
    required this.monthOptions,
    required this.selectedMonth,
    required this.studentPresencePercent,
    required this.teacherPresencePercent,
    required this.weeklyChart,
    required this.monthlyChart,
    required this.classStats,
    required this.teacherStats,
  });

  final List<String> monthOptions;
  final String selectedMonth;
  final double studentPresencePercent;
  final double teacherPresencePercent;
  final List<ChartPoint> weeklyChart;
  final List<ChartPoint> monthlyChart;
  final List<ClassAttendanceStat> classStats;
  final List<TeacherAttendanceStat> teacherStats;
}

class KepsekScheduleMonitoring {
  const KepsekScheduleMonitoring({
    required this.dateLabel,
    required this.classFilters,
    required this.teacherFilters,
    required this.selectedClass,
    required this.selectedTeacher,
    required this.items,
  });

  final String dateLabel;
  final List<String> classFilters;
  final List<String> teacherFilters;
  final String selectedClass;
  final String selectedTeacher;
  final List<SchoolScheduleItem> items;
}

class KepsekAcademicReport {
  const KepsekAcademicReport({
    required this.studentPresencePercent,
    required this.teacherPresencePercent,
    required this.monthlyChart,
    required this.classStats,
    required this.teacherStats,
    required this.summaryNote,
  });

  final double studentPresencePercent;
  final double teacherPresencePercent;
  final List<ChartPoint> monthlyChart;
  final List<ClassAttendanceStat> classStats;
  final List<TeacherAttendanceStat> teacherStats;
  final String summaryNote;
}
