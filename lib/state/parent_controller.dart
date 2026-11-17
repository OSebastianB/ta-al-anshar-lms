import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/parent_models.dart';
import '../repositories/parent_repository.dart';
import 'async_runner.dart';
import 'load_state.dart';

export 'load_state.dart';

/// State layar role Orang Tua.
///
/// Semua request membawa `parentUserId` dari sesi login (lihat [bindParent]),
/// sehingga orang tua hanya bisa melihat anak yang terhubung ke akunnya.
/// Bila punya lebih dari satu anak, [selectedChildId] menentukan anak aktif.
class ParentController extends ChangeNotifier with AsyncRunner {
  ParentController({required this.repository});

  final ParentRepository repository;

  String? _parentUserId;
  String? selectedChildId;

  LoadState dashboardState = LoadState.idle;
  LoadState attendanceState = LoadState.idle;
  LoadState scheduleState = LoadState.idle;
  LoadState childrenState = LoadState.idle;

  String? dashboardError;
  String? attendanceError;
  String? scheduleError;
  String? childrenError;

  List<LinkedChild> linkedChildren = const [];
  ParentDashboardData? dashboard;
  ParentAttendanceData? attendance;
  ParentScheduleData? schedule;

  LinkedChild? get activeChild {
    if (linkedChildren.isEmpty) return null;
    if (selectedChildId == null) return linkedChildren.first;
    for (final child in linkedChildren) {
      if (child.id == selectedChildId) return child;
    }
    return linkedChildren.first;
  }

  /// Mengikat controller ke akun yang login. Jika akun berganti, data anak
  /// sebelumnya dibuang agar tidak bocor ke akun lain.
  void bindParent(String parentUserId) {
    if (_parentUserId == parentUserId) return;
    _parentUserId = parentUserId;
    selectedChildId = null;
    linkedChildren = const [];
    dashboard = null;
    attendance = null;
    schedule = null;
  }

  String get _requireParentId {
    final id = _parentUserId;
    if (id == null || id.isEmpty) {
      throw const DataException(
        'Sesi orang tua tidak valid.',
        code: 'unauthenticated',
      );
    }
    return id;
  }

  /// `no_linked_child` bukan kegagalan teknis: tampilkan sebagai kosong.
  static LoadState _emptyIfNoChild(DataException error) {
    return error.code == 'no_linked_child' ? LoadState.empty : LoadState.error;
  }

  Future<void> _ensureChildrenLoaded() async {
    if (linkedChildren.isEmpty) await loadLinkedChildren();
  }

  Future<void> loadLinkedChildren() => runLoad(
        update: (state, error) {
          childrenState = state;
          childrenError = error;
        },
        fallbackError: 'Gagal memuat data anak terhubung.',
        task: () async {
          linkedChildren = await repository.fetchLinkedChildren(
            parentUserId: _requireParentId,
          );
          if (linkedChildren.isEmpty) {
            selectedChildId = null;
            return LoadState.empty;
          }
          final stillLinked =
              linkedChildren.any((child) => child.id == selectedChildId);
          if (!stillLinked) selectedChildId = linkedChildren.first.id;
          return LoadState.ready;
        },
      );

  /// Ganti anak aktif lalu muat ulang semua tab untuk anak tersebut.
  Future<void> selectChild(String childId) async {
    final allowed = linkedChildren.any((child) => child.id == childId);
    if (!allowed) {
      childrenError = 'Anak tidak terhubung dengan akun Anda.';
      notifyListeners();
      return;
    }
    selectedChildId = childId;
    await Future.wait([
      loadDashboard(),
      loadAttendance(),
      loadSchedule(),
    ]);
  }

  Future<void> loadDashboard() => runLoad(
        update: (state, error) {
          dashboardState = state;
          dashboardError = error;
        },
        fallbackError: 'Gagal memuat dashboard orang tua.',
        stateOnError: _emptyIfNoChild,
        task: () async {
          await _ensureChildrenLoaded();
          final data = await repository.fetchDashboard(
            parentUserId: _requireParentId,
            childId: selectedChildId,
          );
          dashboard = data;
          selectedChildId = data.child.id;
          return LoadState.ready;
        },
      );

  Future<void> loadAttendance({String? month}) => runLoad(
        update: (state, error) {
          attendanceState = state;
          attendanceError = error;
        },
        fallbackError: 'Gagal memuat kehadiran anak.',
        stateOnError: _emptyIfNoChild,
        task: () async {
          await _ensureChildrenLoaded();
          final data = await repository.fetchAttendance(
            parentUserId: _requireParentId,
            childId: selectedChildId,
            month: month,
          );
          attendance = data;
          selectedChildId = data.child.id;
          return LoadState.ready;
        },
      );

  Future<void> loadSchedule({String? dayKey}) => runLoad(
        update: (state, error) {
          scheduleState = state;
          scheduleError = error;
        },
        fallbackError: 'Gagal memuat jadwal pelajaran.',
        stateOnError: _emptyIfNoChild,
        task: () async {
          await _ensureChildrenLoaded();
          final data = await repository.fetchSchedule(
            parentUserId: _requireParentId,
            childId: selectedChildId,
            dayKey: dayKey ?? schedule?.selectedDayKey,
          );
          schedule = data;
          selectedChildId = data.child.id;
          return LoadState.ready;
        },
      );

  Future<void> selectScheduleDay(String dayKey) {
    return loadSchedule(dayKey: dayKey);
  }
}

/// Menyediakan [ParentController] ke semua layar di bawah `OrangtuaShell`.
class ParentScope extends InheritedNotifier<ParentController> {
  const ParentScope({
    super.key,
    required ParentController controller,
    required super.child,
  }) : super(notifier: controller);

  static ParentController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ParentScope>();
    assert(scope != null, 'ParentScope tidak ditemukan');
    return scope!.notifier!;
  }
}
