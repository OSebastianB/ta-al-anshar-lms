import '../core/config/app_config.dart';
import '../core/errors/data_exception.dart';
import '../data/dummy_data.dart';
import '../models/kepsek_models.dart';
import 'kepsek_repository.dart';

/// Mock Kepala Sekolah. Hanya user role kepsek yang diizinkan.
class MockKepsekRepository implements KepsekRepository {
  MockKepsekRepository({
    this.networkDelay = AppConfig.mockNetworkDelay,
  }) : _approvals = DummyData.createScheduleApprovals(),
       _announcements =
           List<SchoolAnnouncement>.from(DummyData.schoolAnnouncements);

  final Duration networkDelay;
  final List<ScheduleApprovalItem> _approvals;
  final List<SchoolAnnouncement> _announcements;

  static const _allowedKepsekIds = {'usr-kepsek-001'};

  Future<void> _delay() => Future<void>.delayed(networkDelay);

  void _assertKepsek(String kepsekUserId) {
    if (!_allowedKepsekIds.contains(kepsekUserId)) {
      throw const DataException(
        'Akses ditolak. Fitur ini hanya untuk Kepala Sekolah.',
        code: 'forbidden',
      );
    }
  }

  @override
  Future<KepsekDashboardData> fetchDashboard({
    required String kepsekUserId,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    final pending = _approvals
        .where((item) => item.status == ScheduleApprovalStatus.menunggu)
        .length;

    return KepsekDashboardData(
      dateLabel: DummyData.demoDateLabel,
      totalStudents: DummyData.totalStudents,
      totalTeachers: DummyData.totalTeachers,
      totalClasses: DummyData.totalClasses,
      studentPresencePercent: DummyData.studentPresencePercent,
      teacherPresencePercent: DummyData.teacherPresencePercent,
      pendingApprovals: pending,
      activities: List<AnnouncementItem>.from(DummyData.schoolActivities),
      todaySchedule:
          List<SchoolScheduleItem>.from(DummyData.todaySchoolSchedule),
      notices: List<AppNotice>.from(DummyData.kepsekNotices),
    );
  }

  @override
  Future<KepsekAttendanceMonitoring> fetchAttendanceMonitoring({
    required String kepsekUserId,
    String? month,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    final months = List<String>.from(DummyData.monthFilters);
    final selected = month ?? months.first;
    if (!months.contains(selected)) {
      throw DataException('Bulan $selected tidak valid.', code: 'invalid_month');
    }

    // Mock: angka sedikit disesuaikan untuk bulan non-aktif.
    final factor = selected == months.first ? 1.0 : 0.97;

    return KepsekAttendanceMonitoring(
      monthOptions: months,
      selectedMonth: selected,
      studentPresencePercent: DummyData.studentPresencePercent * factor,
      teacherPresencePercent: DummyData.teacherPresencePercent * factor,
      weeklyChart: List<ChartPoint>.from(DummyData.weeklyPresenceChart),
      monthlyChart: List<ChartPoint>.from(DummyData.monthlyPresenceChart),
      classStats: List<ClassAttendanceStat>.from(DummyData.classAttendanceStats),
      teacherStats:
          List<TeacherAttendanceStat>.from(DummyData.teacherAttendanceStats),
    );
  }

  @override
  Future<KepsekScheduleMonitoring> fetchScheduleMonitoring({
    required String kepsekUserId,
    String? classFilter,
    String? teacherFilter,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    final classFilters = List<String>.from(DummyData.schoolClassFilters);
    final teacherFilters = List<String>.from(DummyData.schoolTeacherFilters);
    final selectedClass = classFilter ?? classFilters.first;
    final selectedTeacher = teacherFilter ?? teacherFilters.first;

    if (!classFilters.contains(selectedClass)) {
      throw DataException(
        'Filter kelas tidak valid.',
        code: 'invalid_filter',
      );
    }
    if (!teacherFilters.contains(selectedTeacher)) {
      throw DataException(
        'Filter guru tidak valid.',
        code: 'invalid_filter',
      );
    }

    final items = DummyData.todaySchoolSchedule.where((item) {
      final classOk =
          selectedClass == 'Semua kelas' || item.className == selectedClass;
      final teacherOk = selectedTeacher == 'Semua guru' ||
          item.teacher == selectedTeacher;
      return classOk && teacherOk;
    }).toList();

    return KepsekScheduleMonitoring(
      dateLabel: DummyData.demoDateLabel,
      classFilters: classFilters,
      teacherFilters: teacherFilters,
      selectedClass: selectedClass,
      selectedTeacher: selectedTeacher,
      items: items,
    );
  }

  @override
  Future<KepsekAcademicReport> fetchAcademicReport({
    required String kepsekUserId,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    return KepsekAcademicReport(
      studentPresencePercent: DummyData.studentPresencePercent,
      teacherPresencePercent: DummyData.teacherPresencePercent,
      monthlyChart: List<ChartPoint>.from(DummyData.monthlyPresenceChart),
      classStats: List<ClassAttendanceStat>.from(DummyData.classAttendanceStats),
      teacherStats:
          List<TeacherAttendanceStat>.from(DummyData.teacherAttendanceStats),
      summaryNote:
          'Rekapitulasi kehadiran dan ringkasan akademik sekolah untuk tinjauan Kepala Sekolah. Generate jadwal otomatis tidak tersedia di aplikasi mobile.',
    );
  }

  @override
  Future<List<ScheduleApprovalItem>> fetchScheduleApprovals({
    required String kepsekUserId,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    return List<ScheduleApprovalItem>.from(_approvals);
  }

  @override
  Future<ScheduleApprovalItem> updateApprovalStatus({
    required String kepsekUserId,
    required String approvalId,
    required ScheduleApprovalStatus status,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);

    final index = _approvals.indexWhere((item) => item.id == approvalId);
    if (index < 0) {
      throw const DataException(
        'Pengajuan jadwal tidak ditemukan.',
        code: 'not_found',
      );
    }
    if (status == ScheduleApprovalStatus.menunggu) {
      throw const DataException(
        'Status tujuan tidak valid.',
        code: 'validation',
      );
    }

    final current = _approvals[index];
    current.status = status;
    return current;
  }

  @override
  Future<List<SchoolAnnouncement>> fetchAnnouncements({
    required String kepsekUserId,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    return List<SchoolAnnouncement>.from(_announcements);
  }

  @override
  Future<SchoolAnnouncement> createAnnouncement({
    required String kepsekUserId,
    required String title,
    required String body,
  }) async {
    await _delay();
    _assertKepsek(kepsekUserId);
    final trimmedTitle = title.trim();
    final trimmedBody = body.trim();
    if (trimmedTitle.isEmpty || trimmedBody.isEmpty) {
      throw const DataException(
        'Judul dan isi pengumuman wajib diisi.',
        code: 'validation',
      );
    }

    final created = SchoolAnnouncement(
      id: 'ann-${DateTime.now().millisecondsSinceEpoch}',
      title: trimmedTitle,
      body: trimmedBody,
      dateLabel: 'Hari ini',
      author: 'Kepala Sekolah',
      published: false,
    );
    _announcements.insert(0, created);
    return created;
  }
}
