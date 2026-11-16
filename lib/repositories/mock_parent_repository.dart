import '../core/config/app_config.dart';
import '../core/errors/data_exception.dart';
import '../data/dummy_data.dart';
import '../models/parent_models.dart';
import 'parent_repository.dart';

/// Mock Orang Tua: data difilter ketat berdasarkan parentUserId → anak terhubung.
class MockParentRepository implements ParentRepository {
  MockParentRepository({
    this.networkDelay = AppConfig.mockNetworkDelay,
  });

  final Duration networkDelay;

  static const _aulia = LinkedChild(
    id: 'child-001',
    nis: '2024510001',
    name: 'Aulia Zahra Ramadhani',
    initials: 'AZ',
    className: 'V-A',
    classLabel: 'Kelas V-A',
    homeroomTeacher: 'Bu Ratna Sari',
  );

  /// Mapping akun orang tua → anak yang boleh dilihat.
  /// Akun lain (guru/kepsek/unknown) tidak punya anak.
  static const Map<String, List<LinkedChild>> _childrenByParent = {
    'usr-ortu-001': [_aulia],
  };

  Future<void> _delay() => Future<void>.delayed(networkDelay);

  List<LinkedChild> _childrenOf(String parentUserId) {
    return List<LinkedChild>.from(
      _childrenByParent[parentUserId] ?? const <LinkedChild>[],
    );
  }

  LinkedChild _resolveChild({
    required String parentUserId,
    String? childId,
  }) {
    final children = _childrenOf(parentUserId);
    if (children.isEmpty) {
      throw const DataException(
        'Tidak ada data anak yang terhubung dengan akun ini.',
        code: 'no_linked_child',
      );
    }

    if (childId == null || childId.isEmpty) {
      return children.first;
    }

    for (final child in children) {
      if (child.id == childId) return child;
    }

    throw const DataException(
      'Akses ditolak. Anak tidak terhubung dengan akun Anda.',
      code: 'child_not_linked',
    );
  }

  bool _matchesMonth(ChildAttendanceDay item, String month) {
    final label = item.dateLabel.toLowerCase();
    if (month.startsWith('November')) return label.contains('nov');
    if (month.startsWith('Oktober')) return label.contains('okt');
    if (month.startsWith('September')) return label.contains('sep');
    return true;
  }

  List<AttendanceSlice> _summaryFor(List<ChildAttendanceDay> days) {
    final counts = {
      for (final status in AttendanceStatus.values) status: 0,
    };
    for (final day in days) {
      counts[day.status] = (counts[day.status] ?? 0) + 1;
    }
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

  double _presentPercent(List<ChildAttendanceDay> days) {
    if (days.isEmpty) return 0;
    final present =
        days.where((item) => item.status == AttendanceStatus.hadir).length;
    return present / days.length * 100;
  }

  @override
  Future<List<LinkedChild>> fetchLinkedChildren({
    required String parentUserId,
  }) async {
    await _delay();
    return _childrenOf(parentUserId);
  }

  @override
  Future<ParentDashboardData> fetchDashboard({
    required String parentUserId,
    String? childId,
  }) async {
    await _delay();
    final child = _resolveChild(parentUserId: parentUserId, childId: childId);
    final todaySchedule = List<ScheduleItem>.from(
      DummyData.childWeeklySchedule['senin'] ?? const <ScheduleItem>[],
    );
    final history = List<ChildAttendanceDay>.from(DummyData.childAttendanceDays);

    return ParentDashboardData(
      dateLabel: DummyData.demoDateLabel,
      child: child,
      todayStatus: history.isEmpty
          ? AttendanceStatus.hadir
          : history.first.status,
      monthlyPresentPercent: _presentPercent(history),
      todaySchedule: todaySchedule,
      announcements: List<AnnouncementItem>.from(DummyData.parentAnnouncements),
      notices: List<AppNotice>.from(DummyData.parentNotices),
    );
  }

  @override
  Future<ParentAttendanceData> fetchAttendance({
    required String parentUserId,
    String? childId,
    String? month,
  }) async {
    await _delay();
    final child = _resolveChild(parentUserId: parentUserId, childId: childId);
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

    final allDays =
        List<ChildAttendanceDay>.from(DummyData.childAttendanceDays);
    final filtered =
        allDays.where((item) => _matchesMonth(item, selected)).toList();

    return ParentAttendanceData(
      child: child,
      dateLabel: DummyData.demoDateLabel,
      todayStatus: allDays.isEmpty
          ? AttendanceStatus.hadir
          : allDays.first.status,
      todayNote: allDays.isEmpty
          ? 'Belum ada catatan kehadiran hari ini'
          : allDays.first.note,
      monthOptions: months,
      selectedMonth: selected,
      monthlyPresentPercent: _presentPercent(filtered),
      monthSummary: filtered.isEmpty
          ? _summaryFor(const [])
          : (selected == months.first
              ? List<AttendanceSlice>.from(DummyData.childAttendanceMonth)
              : _summaryFor(filtered)),
      history: filtered,
    );
  }

  @override
  Future<ParentScheduleData> fetchSchedule({
    required String parentUserId,
    String? childId,
    String? dayKey,
  }) async {
    await _delay();
    final child = _resolveChild(parentUserId: parentUserId, childId: childId);
    final weekDays = List<WeekDay>.from(DummyData.weekDays);
    if (weekDays.isEmpty) {
      throw const DataException(
        'Kalender jadwal belum tersedia.',
        code: 'options_empty',
      );
    }
    final selected = dayKey ?? weekDays.first.key;
    final valid = weekDays.any((day) => day.key == selected);
    if (!valid) {
      throw DataException('Hari $selected tidak valid.', code: 'invalid_day');
    }

    final items = List<ScheduleItem>.from(
      DummyData.childWeeklySchedule[selected] ?? const <ScheduleItem>[],
    );

    return ParentScheduleData(
      child: child,
      weekDays: weekDays,
      selectedDayKey: selected,
      items: items,
    );
  }
}
