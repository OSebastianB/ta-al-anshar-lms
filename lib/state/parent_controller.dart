import 'package:flutter/widgets.dart';

import '../core/errors/data_exception.dart';
import '../models/parent_models.dart';
import '../repositories/parent_repository.dart';
import 'load_state.dart';

export 'load_state.dart';

class ParentController extends ChangeNotifier {
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

  Future<void> loadLinkedChildren() async {
    childrenState = LoadState.loading;
    childrenError = null;
    notifyListeners();
    try {
      linkedChildren = await repository.fetchLinkedChildren(
        parentUserId: _requireParentId,
      );
      if (linkedChildren.isEmpty) {
        selectedChildId = null;
        childrenState = LoadState.empty;
      } else {
        selectedChildId ??= linkedChildren.first.id;
        final exists = linkedChildren.any((c) => c.id == selectedChildId);
        if (!exists) selectedChildId = linkedChildren.first.id;
        childrenState = LoadState.ready;
      }
    } on DataException catch (error) {
      childrenError = error.message;
      childrenState = LoadState.error;
    } catch (_) {
      childrenError = 'Gagal memuat data anak terhubung.';
      childrenState = LoadState.error;
    }
    notifyListeners();
  }

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

  Future<void> loadDashboard() async {
    dashboardState = LoadState.loading;
    dashboardError = null;
    notifyListeners();
    try {
      if (linkedChildren.isEmpty) {
        await loadLinkedChildren();
      }
      dashboard = await repository.fetchDashboard(
        parentUserId: _requireParentId,
        childId: selectedChildId,
      );
      selectedChildId = dashboard!.child.id;
      dashboardState = LoadState.ready;
    } on DataException catch (error) {
      dashboardError = error.message;
      dashboardState = error.code == 'no_linked_child'
          ? LoadState.empty
          : LoadState.error;
    } catch (_) {
      dashboardError = 'Gagal memuat dashboard orang tua.';
      dashboardState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadAttendance({String? month}) async {
    attendanceState = LoadState.loading;
    attendanceError = null;
    notifyListeners();
    try {
      if (linkedChildren.isEmpty) {
        await loadLinkedChildren();
      }
      attendance = await repository.fetchAttendance(
        parentUserId: _requireParentId,
        childId: selectedChildId,
        month: month,
      );
      selectedChildId = attendance!.child.id;
      attendanceState = LoadState.ready;
    } on DataException catch (error) {
      attendanceError = error.message;
      attendanceState = error.code == 'no_linked_child'
          ? LoadState.empty
          : LoadState.error;
    } catch (_) {
      attendanceError = 'Gagal memuat kehadiran anak.';
      attendanceState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> loadSchedule({String? dayKey}) async {
    scheduleState = LoadState.loading;
    scheduleError = null;
    notifyListeners();
    try {
      if (linkedChildren.isEmpty) {
        await loadLinkedChildren();
      }
      schedule = await repository.fetchSchedule(
        parentUserId: _requireParentId,
        childId: selectedChildId,
        dayKey: dayKey ?? schedule?.selectedDayKey,
      );
      selectedChildId = schedule!.child.id;
      scheduleState = LoadState.ready;
    } on DataException catch (error) {
      scheduleError = error.message;
      scheduleState = error.code == 'no_linked_child'
          ? LoadState.empty
          : LoadState.error;
    } catch (_) {
      scheduleError = 'Gagal memuat jadwal pelajaran.';
      scheduleState = LoadState.error;
    }
    notifyListeners();
  }

  Future<void> selectScheduleDay(String dayKey) {
    return loadSchedule(dayKey: dayKey);
  }
}

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
