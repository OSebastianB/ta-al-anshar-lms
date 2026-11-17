import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/guru_dashboard.dart';
import '../models/models.dart';
import '../repositories/guru_repository.dart';
import 'async_runner.dart';
import 'load_state.dart';

export 'load_state.dart';

/// State seluruh layar role Guru: dashboard, jadwal, kelas, absensi, riwayat.
///
/// Dibuat oleh `GuruShell` dan disediakan ke layar lewat [GuruScope].
/// Setiap bagian layar punya pasangan `xxxState` + `xxxError` sendiri agar
/// kegagalan satu bagian tidak mengosongkan bagian lain.
class GuruController extends ChangeNotifier with AsyncRunner {
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

  // ---------------------------------------------------------------------------
  // Dashboard & jadwal
  // ---------------------------------------------------------------------------

  Future<void> loadDashboard() => runLoad(
        update: (state, error) {
          dashboardState = state;
          dashboardError = error;
        },
        fallbackError: 'Gagal memuat dashboard guru.',
        task: () async {
          dashboard = await repository.fetchDashboard();
          return LoadState.ready;
        },
      );

  /// Memuat jadwal untuk [dayKey]. Tanpa [dayKey], hari yang sedang dipilih
  /// dipertahankan; jika belum ada, dipakai hari pertama minggu ini.
  Future<void> loadSchedule({String? dayKey}) => runLoad(
        update: (state, error) {
          scheduleState = state;
          scheduleError = error;
        },
        fallbackError: 'Gagal memuat jadwal mengajar.',
        task: () async {
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
          return stateForList(scheduleItems);
        },
      );

  Future<void> selectScheduleDay(String dayKey) {
    return loadSchedule(dayKey: dayKey);
  }

  // ---------------------------------------------------------------------------
  // Kelas & siswa
  // ---------------------------------------------------------------------------

  Future<void> loadClasses() => runLoad(
        update: (state, error) {
          classesState = state;
          classesError = error;
        },
        fallbackError: 'Gagal memuat daftar kelas.',
        task: () async {
          classes = await repository.fetchClasses();
          return stateForList(classes);
        },
      );

  Future<void> loadClassStudents(String className) => runLoad(
        update: (state, error) {
          studentsState = state;
          studentsError = error;
        },
        fallbackError: 'Gagal memuat daftar siswa.',
        task: () async {
          classStudents = await repository.fetchStudentsByClass(className);
          return stateForList(classStudents);
        },
      );

  // ---------------------------------------------------------------------------
  // Absensi
  // ---------------------------------------------------------------------------

  Future<void> loadAttendanceDraft({String? className, String? subject}) =>
      runLoad(
        update: (state, error) {
          attendanceState = state;
          attendanceError = error;
        },
        fallbackError: 'Gagal memuat form absensi.',
        task: () async {
          final draft = await repository.fetchAttendanceDraft(
            className: className,
            subject: subject,
          );
          attendanceDraft = draft;
          return stateForList(draft.students);
        },
      );

  /// Mengubah status satu siswa di draft lokal. Belum tersimpan ke server
  /// sampai [saveAttendance] dipanggil.
  void setAttendanceStatus(String nis, AttendanceStatus status) {
    final draft = attendanceDraft;
    if (draft == null) return;
    final next = Map<String, AttendanceStatus>.from(draft.statuses);
    next[nis] = status;
    attendanceDraft = draft.copyWith(statuses: next);
    attendanceError = null;
    notifyListeners();
  }

  /// Ganti kelas memuat ulang daftar siswa, mapel yang dipilih dipertahankan.
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

  /// Menyimpan absensi. Semua siswa wajib punya status sebelum dikirim.
  ///
  /// Melempar [DataException] bila validasi atau penyimpanan gagal; pesan
  /// yang sama juga ditaruh di [attendanceError] untuk ditampilkan di form.
  Future<AttendanceHistoryItem?> saveAttendance() async {
    final draft = attendanceDraft;
    if (draft == null) {
      attendanceError = 'Form absensi belum siap.';
      notifyListeners();
      return null;
    }
    _validateAttendance(draft);

    return runAction(
      setBusy: (busy) => isSavingAttendance = busy,
      setError: (error) => attendanceError = error,
      fallbackError: 'Gagal menyimpan absensi.',
      task: () => repository.saveAttendance(
        className: draft.className,
        subject: draft.subject,
        dateLabel: draft.dateLabel,
        statuses: draft.statuses,
      ),
    );
  }

  void _validateAttendance(AttendanceDraft draft) {
    String? message;
    if (draft.students.isEmpty) {
      message = 'Tidak ada siswa pada kelas ini.';
    } else if (draft.students
        .any((student) => !draft.statuses.containsKey(student.nis))) {
      message = 'Lengkapi status kehadiran semua siswa.';
    }
    if (message == null) return;

    attendanceError = message;
    notifyListeners();
    throw DataException(message, code: 'validation');
  }

  Future<void> loadAttendanceHistory({String? month}) => runLoad(
        update: (state, error) {
          historyState = state;
          historyError = error;
        },
        fallbackError: 'Gagal memuat riwayat absensi.',
        task: () async {
          final bundle = await repository.fetchAttendanceHistory(month: month);
          history = bundle;
          return stateForList(bundle.items);
        },
      );
}

/// Menyediakan [GuruController] ke semua layar di bawah `GuruShell`.
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
