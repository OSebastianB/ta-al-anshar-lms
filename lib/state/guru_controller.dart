import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/guru_dashboard.dart';
import '../models/models.dart';
import '../repositories/guru_repository.dart';
import 'load_state.dart';

export 'load_state.dart';

class GuruController extends ChangeNotifier {
  GuruController({required this.repository});

  final GuruRepository repository;

  LoadState dashboardState = LoadState.idle;
  LoadState scheduleState = LoadState.idle;
  LoadState classesState = LoadState.idle;
  LoadState studentsState = LoadState.idle;
  LoadState attendanceState = LoadState.idle;
  LoadState historyState = LoadState.idle;

  String? dashboardError;
  String? scheduleError;
  String? classesError;
  String? studentsError;
  String? attendanceError;
  String? historyError;

  GuruDashboardData? dashboard;
  List<WeekDay> weekDays = const [];
  String selectedDayKey = '';
  List<ScheduleItem> scheduleItems = const [];
  List<ClassItem> classes = const [];
  List<StudentItem> classStudents = const [];
  AttendanceDraft? attendanceDraft;
  AttendanceHistoryBundle? history;
  bool isSavingAttendance = false;

  WeekDay? get selectedDay {
    if (weekDays.isEmpty || selectedDayKey.isEmpty) return null;
    for (final day in weekDays) {
      if (day.key == selectedDayKey) return day;
    }
    return weekDays.first;
  }

  Future<void> loadDashboard() async {
    dashboardState = LoadState.loading;
    dashboardError = null;
    notifyListeners();
    try {
      dashboard = await repository.fetchDashboard();
      dashboardState = LoadState.ready;
    } on DataException catch (error) {
      dashboardError = error.message;
      dashboardState = LoadState.error;
    } catch (_) {
      dashboardError = 'Gagal memuat dashboard guru.';
      dashboardState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadSchedule({String? dayKey}) async {
    scheduleState = LoadState.loading;
    scheduleError = null;
    notifyListeners();
    try {
      if (weekDays.isEmpty) {
        weekDays = await repository.fetchWeekDays();
        selectedDayKey =
            dayKey ?? (weekDays.isEmpty ? '' : weekDays.first.key);
      } else if (dayKey != null) {
        selectedDayKey = dayKey;
      } else if (selectedDayKey.isEmpty && weekDays.isNotEmpty) {
        selectedDayKey = weekDays.first.key;
      }

      scheduleItems = await repository.fetchScheduleForDay(selectedDayKey);
      scheduleState = scheduleItems.isEmpty
          ? LoadState.empty
          : LoadState.ready;
    } on DataException catch (error) {
      scheduleError = error.message;
      scheduleState = LoadState.error;
    } catch (_) {
      scheduleError = 'Gagal memuat jadwal mengajar.';
      scheduleState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> selectScheduleDay(String dayKey) {
    return loadSchedule(dayKey: dayKey);
  }

  Future<void> loadClasses() async {
    classesState = LoadState.loading;
    classesError = null;
    notifyListeners();
    try {
      classes = await repository.fetchClasses();
      classesState =
          classes.isEmpty ? LoadState.empty : LoadState.ready;
    } on DataException catch (error) {
      classesError = error.message;
      classesState = LoadState.error;
    } catch (_) {
      classesError = 'Gagal memuat daftar kelas.';
      classesState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadClassStudents(String className) async {
    studentsState = LoadState.loading;
    studentsError = null;
    notifyListeners();
    try {
      classStudents = await repository.fetchStudentsByClass(className);
      studentsState =
          classStudents.isEmpty ? LoadState.empty : LoadState.ready;
    } on DataException catch (error) {
      studentsError = error.message;
      studentsState = LoadState.error;
    } catch (_) {
      studentsError = 'Gagal memuat daftar siswa.';
      studentsState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadAttendanceDraft({String? className, String? subject}) async {
    attendanceState = LoadState.loading;
    attendanceError = null;
    notifyListeners();
    try {
      attendanceDraft = await repository.fetchAttendanceDraft(
        className: className,
        subject: subject,
      );
      attendanceState = attendanceDraft!.students.isEmpty
          ? LoadState.empty
          : LoadState.ready;
    } on DataException catch (error) {
      attendanceError = error.message;
      attendanceState = LoadState.error;
    } catch (_) {
      attendanceError = 'Gagal memuat form absensi.';
      attendanceState = LoadState.error;
    }
    notifyListeners();
  }

  void setAttendanceStatus(String nis, AttendanceStatus status) {
    final draft = attendanceDraft;
    if (draft == null) return;
    final next = Map<String, AttendanceStatus>.from(draft.statuses);
    next[nis] = status;
    attendanceDraft = draft.copyWith(statuses: next);
    attendanceError = null;
    notifyListeners();
  }

  Future<void> changeAttendanceClass(String className) {
    return loadAttendanceDraft(
      className: className,
      subject: attendanceDraft?.subject,
    );
  }

  Future<void> changeAttendanceSubject(String subject) async {
    final draft = attendanceDraft;
    if (draft == null) return;
    attendanceDraft = draft.copyWith(subject: subject);
    attendanceError = null;
    notifyListeners();
  }

  Future<AttendanceHistoryItem?> saveAttendance() async {
    final draft = attendanceDraft;
    if (draft == null) {
      attendanceError = 'Form absensi belum siap.';
      notifyListeners();
      return null;
    }
    if (draft.students.isEmpty) {
      attendanceError = 'Tidak ada siswa pada kelas ini.';
      notifyListeners();
      throw const DataException(
        'Tidak ada siswa pada kelas ini.',
        code: 'validation',
      );
    }
    for (final student in draft.students) {
      if (!draft.statuses.containsKey(student.nis)) {
        attendanceError = 'Lengkapi status kehadiran semua siswa.';
        notifyListeners();
        throw DataException(attendanceError!, code: 'validation');
      }
    }

    isSavingAttendance = true;
    attendanceError = null;
    notifyListeners();
    try {
      final saved = await repository.saveAttendance(
        className: draft.className,
        subject: draft.subject,
        dateLabel: draft.dateLabel,
        statuses: draft.statuses,
      );
      return saved;
    } on DataException catch (error) {
      attendanceError = error.message;
      rethrow;
    } catch (_) {
      attendanceError = 'Gagal menyimpan absensi.';
      throw DataException(attendanceError!, code: 'unknown');
    } finally {
      isSavingAttendance = false;
      notifyListeners();
    }
  }

  Future<void> loadAttendanceHistory({String? month}) async {
    historyState = LoadState.loading;
    historyError = null;
    notifyListeners();
    try {
      history = await repository.fetchAttendanceHistory(month: month);
      historyState =
          history!.items.isEmpty ? LoadState.empty : LoadState.ready;
    } on DataException catch (error) {
      historyError = error.message;
      historyState = LoadState.error;
    } catch (_) {
      historyError = 'Gagal memuat riwayat absensi.';
      historyState = LoadState.error;
    }
    notifyListeners();
  }
}

class GuruScope extends InheritedNotifier<GuruController> {
  const GuruScope({
    super.key,
    required GuruController controller,
    required super.child,
  }) : super(notifier: controller);

  static GuruController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<GuruScope>();
    assert(scope != null, 'GuruScope tidak ditemukan');
    return scope!.notifier!;
  }

  static GuruController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GuruScope>()?.notifier;
  }
}
