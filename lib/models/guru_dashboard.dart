import 'models.dart';

class GuruDashboardData {
  const GuruDashboardData({
    required this.dateLabel,
    required this.todaySchedule,
    required this.classes,
    required this.announcements,
    required this.attendanceSummary,
    required this.attendanceSummaryHint,
  });

  final String dateLabel;
  final List<ScheduleItem> todaySchedule;
  final List<ClassItem> classes;
  final List<AnnouncementItem> announcements;
  final List<AttendanceSlice> attendanceSummary;
  final String attendanceSummaryHint;

  int get todaySessionCount => todaySchedule.length;

  String get classHint {
    if (classes.isEmpty) return 'Belum ada kelas';
    return classes.map((item) => item.name).join(', ');
  }
}

class AttendanceDraft {
  const AttendanceDraft({
    required this.className,
    required this.subject,
    required this.dateLabel,
    required this.classOptions,
    required this.subjectOptions,
    required this.students,
    required this.statuses,
  });

  final String className;
  final String subject;
  final String dateLabel;
  final List<String> classOptions;
  final List<String> subjectOptions;
  final List<StudentItem> students;
  final Map<String, AttendanceStatus> statuses;

  AttendanceDraft copyWith({
    String? className,
    String? subject,
    List<StudentItem>? students,
    Map<String, AttendanceStatus>? statuses,
  }) {
    return AttendanceDraft(
      className: className ?? this.className,
      subject: subject ?? this.subject,
      dateLabel: dateLabel,
      classOptions: classOptions,
      subjectOptions: subjectOptions,
      students: students ?? this.students,
      statuses: statuses ?? this.statuses,
    );
  }
}

class AttendanceHistoryBundle {
  const AttendanceHistoryBundle({
    required this.monthOptions,
    required this.selectedMonth,
    required this.items,
    required this.summary,
    required this.presentPercent,
    required this.summaryLabel,
  });

  final List<String> monthOptions;
  final String selectedMonth;
  final List<AttendanceHistoryItem> items;
  final List<AttendanceSlice> summary;
  final double presentPercent;
  final String summaryLabel;
}
