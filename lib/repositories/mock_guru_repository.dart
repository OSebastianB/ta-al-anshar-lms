import '../core/config/app_config.dart';
import '../core/errors/data_exception.dart';
import '../data/dummy_data.dart';
import '../models/guru_dashboard.dart';
import 'guru_repository.dart';

/// Implementasi mock fitur Guru. Seed dari DummyData; absensi tersimpan di memori.
class MockGuruRepository implements GuruRepository {
  MockGuruRepository({
    this.networkDelay = AppConfig.mockNetworkDelay,
  }) : _history = List<AttendanceHistoryItem>.from(DummyData.attendanceHistory);

  final Duration networkDelay;
  final List<AttendanceHistoryItem> _history;

  Future<void> _delay() => Future<void>.delayed(networkDelay);

  List<StudentItem> _studentsForClass(String className) {
    final match = DummyData.classes.where((item) => item.name == className);
    if (match.isEmpty) {
      throw DataException(
        'Kelas $className tidak ditemukan.',
        code: 'class_not_found',
      );
    }
    return List<StudentItem>.from(match.first.preview);
  }

  List<AttendanceSlice> _slicesFromCounts(Map<AttendanceStatus, int> counts) {
    return [
      for (final status in AttendanceStatus.values)
        AttendanceSlice(
          label: status.label,
          value: counts[status] ?? 0,
          color: status.color,
          background: status.background,
        ),
    ];
  }

  Map<AttendanceStatus, int> _countStatuses(
    Map<String, AttendanceStatus> statuses,
  ) {
    final counts = {
      for (final status in AttendanceStatus.values) status: 0,
    };
    for (final status in statuses.values) {
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  double _presentPercent(List<AttendanceHistoryItem> items) {
    final present = items.fold<int>(0, (sum, item) => sum + item.present);
    final total = items.fold<int>(0, (sum, item) => sum + item.total);
    if (total == 0) return 0;
    return present / total * 100;
  }

  bool _matchesMonth(AttendanceHistoryItem item, String month) {
    final label = item.dateLabel.toLowerCase();
    if (month.startsWith('November')) return label.contains('nov');
    if (month.startsWith('Oktober')) return label.contains('okt');
    if (month.startsWith('September')) return label.contains('sep');
    return true;
  }

  @override
  Future<GuruDashboardData> fetchDashboard() async {
    await _delay();
    final classes = List<ClassItem>.from(DummyData.classes);
    final summary = List<AttendanceSlice>.from(DummyData.attendance);
    final total = summary.fold<int>(0, (sum, item) => sum + item.value);
    final present = summary
        .where((item) => item.label == 'Hadir')
        .fold<int>(0, (sum, item) => sum + item.value);
    final rate = total == 0 ? 0 : (present / total * 100).round();
    final primary = classes.isEmpty ? '—' : classes.first.name;

    return GuruDashboardData(
      dateLabel: DummyData.demoDateLabel,
      todaySchedule: List<ScheduleItem>.from(DummyData.todaySchedule),
      classes: classes,
      announcements: List<AnnouncementItem>.from(DummyData.announcements),
      attendanceSummary: summary,
      attendanceSummaryHint: 'Kelas $primary · $total siswa · $rate% hadir',
    );
  }

  @override
  Future<List<WeekDay>> fetchWeekDays() async {
    await _delay();
    return List<WeekDay>.from(DummyData.weekDays);
  }

  @override
  Future<List<ScheduleItem>> fetchScheduleForDay(String dayKey) async {
    await _delay();
    final items = DummyData.guruWeeklySchedule[dayKey];
    return List<ScheduleItem>.from(items ?? const <ScheduleItem>[]);
  }

  @override
  Future<List<ClassItem>> fetchClasses() async {
    await _delay();
    return List<ClassItem>.from(DummyData.classes);
  }

  @override
  Future<List<StudentItem>> fetchStudentsByClass(String className) async {
    await _delay();
    return _studentsForClass(className);
  }

  @override
  Future<AttendanceDraft> fetchAttendanceDraft({
    String? className,
    String? subject,
  }) async {
    await _delay();
    final classOptions = List<String>.from(DummyData.classOptions);
    final subjectOptions = List<String>.from(DummyData.subjectOptions);
    if (classOptions.isEmpty || subjectOptions.isEmpty) {
      throw const DataException(
        'Opsi kelas atau mata pelajaran belum tersedia.',
        code: 'options_empty',
      );
    }

    final selectedClass = className ?? classOptions.first;
    final selectedSubject = subject ?? subjectOptions.first;
    if (!classOptions.contains(selectedClass)) {
      throw DataException(
        'Kelas $selectedClass tidak valid.',
        code: 'invalid_class',
      );
    }
    if (!subjectOptions.contains(selectedSubject)) {
      throw DataException(
        'Mata pelajaran $selectedSubject tidak valid.',
        code: 'invalid_subject',
      );
    }

    final students = _studentsForClass(selectedClass);
    return AttendanceDraft(
      className: selectedClass,
      subject: selectedSubject,
      dateLabel: DummyData.demoDateLabel,
      classOptions: classOptions,
      subjectOptions: subjectOptions,
      students: students,
      statuses: {
        for (final student in students) student.nis: student.status,
      },
    );
  }

  @override
  Future<AttendanceHistoryItem> saveAttendance({
    required String className,
    required String subject,
    required String dateLabel,
    required Map<String, AttendanceStatus> statuses,
  }) async {
    await _delay();

    if (className.trim().isEmpty) {
      throw const DataException('Kelas wajib dipilih.', code: 'validation');
    }
    if (subject.trim().isEmpty) {
      throw const DataException(
        'Mata pelajaran wajib dipilih.',
        code: 'validation',
      );
    }
    if (statuses.isEmpty) {
      throw const DataException(
        'Daftar siswa kosong. Tidak ada absensi untuk disimpan.',
        code: 'validation',
      );
    }

    final students = _studentsForClass(className);
    for (final student in students) {
      if (!statuses.containsKey(student.nis)) {
        throw DataException(
          'Status kehadiran ${student.name} belum diisi.',
          code: 'validation',
        );
      }
    }

    final counts = _countStatuses(statuses);
    final saved = AttendanceHistoryItem(
      dateLabel: dateLabel,
      className: className,
      subject: subject,
      present: counts[AttendanceStatus.hadir] ?? 0,
      permission: counts[AttendanceStatus.izin] ?? 0,
      sick: counts[AttendanceStatus.sakit] ?? 0,
      absent: counts[AttendanceStatus.alpa] ?? 0,
    );

    _history.insert(0, saved);
    return saved;
  }

  @override
  Future<AttendanceHistoryBundle> fetchAttendanceHistory({
    String? month,
  }) async {
    await _delay();
    final months = List<String>.from(DummyData.monthFilters);
    if (months.isEmpty) {
      throw const DataException(
        'Filter bulan belum tersedia.',
        code: 'options_empty',
      );
    }
    final selected = month ?? months.first;
    if (!months.contains(selected)) {
      throw DataException('Bulan $selected tidak valid.', code: 'invalid_month');
    }

    final effective =
        _history.where((item) => _matchesMonth(item, selected)).toList();

    final summaryCounts = {
      for (final status in AttendanceStatus.values) status: 0,
    };
    for (final item in effective) {
      summaryCounts[AttendanceStatus.hadir] =
          (summaryCounts[AttendanceStatus.hadir] ?? 0) + item.present;
      summaryCounts[AttendanceStatus.izin] =
          (summaryCounts[AttendanceStatus.izin] ?? 0) + item.permission;
      summaryCounts[AttendanceStatus.sakit] =
          (summaryCounts[AttendanceStatus.sakit] ?? 0) + item.sick;
      summaryCounts[AttendanceStatus.alpa] =
          (summaryCounts[AttendanceStatus.alpa] ?? 0) + item.absent;
    }

    return AttendanceHistoryBundle(
      monthOptions: months,
      selectedMonth: selected,
      items: effective,
      summary: _slicesFromCounts(summaryCounts),
      presentPercent: _presentPercent(effective),
      summaryLabel: effective.isEmpty
          ? 'Belum ada rekap untuk $selected'
          : 'Persentase hadir kelas yang diampu · $selected',
    );
  }
}
