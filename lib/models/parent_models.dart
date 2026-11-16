import 'models.dart';

/// Anak yang terhubung ke akun orang tua (kontrak mirip response backend).
class LinkedChild {
  const LinkedChild({
    required this.id,
    required this.nis,
    required this.name,
    required this.initials,
    required this.className,
    required this.classLabel,
    required this.homeroomTeacher,
  });

  final String id;
  final String nis;
  final String name;
  final String initials;
  final String className;
  final String classLabel;
  final String homeroomTeacher;
}

class ParentDashboardData {
  const ParentDashboardData({
    required this.dateLabel,
    required this.child,
    required this.todayStatus,
    required this.monthlyPresentPercent,
    required this.todaySchedule,
    required this.announcements,
    required this.notices,
  });

  final String dateLabel;
  final LinkedChild child;
  final AttendanceStatus todayStatus;
  final double monthlyPresentPercent;
  final List<ScheduleItem> todaySchedule;
  final List<AnnouncementItem> announcements;
  final List<AppNotice> notices;
}

class ParentAttendanceData {
  const ParentAttendanceData({
    required this.child,
    required this.dateLabel,
    required this.todayStatus,
    required this.todayNote,
    required this.monthOptions,
    required this.selectedMonth,
    required this.monthlyPresentPercent,
    required this.monthSummary,
    required this.history,
  });

  final LinkedChild child;
  final String dateLabel;
  final AttendanceStatus todayStatus;
  final String todayNote;
  final List<String> monthOptions;
  final String selectedMonth;
  final double monthlyPresentPercent;
  final List<AttendanceSlice> monthSummary;
  final List<ChildAttendanceDay> history;
}

class ParentScheduleData {
  const ParentScheduleData({
    required this.child,
    required this.weekDays,
    required this.selectedDayKey,
    required this.items,
  });

  final LinkedChild child;
  final List<WeekDay> weekDays;
  final String selectedDayKey;
  final List<ScheduleItem> items;

  WeekDay? get selectedDay {
    for (final day in weekDays) {
      if (day.key == selectedDayKey) return day;
    }
    return weekDays.isEmpty ? null : weekDays.first;
  }
}
