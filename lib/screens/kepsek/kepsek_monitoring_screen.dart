import 'package:material_ui/material_ui.dart';

import '../../state/kepsek_controller.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/attendance_status_chip.dart';
import '../../widgets/section_header.dart';
import '../../widgets/simple_bar_chart.dart';

class KepsekMonitoringScreen extends StatefulWidget {
  const KepsekMonitoringScreen({super.key});

  @override
  State<KepsekMonitoringScreen> createState() => _KepsekMonitoringScreenState();
}

class _KepsekMonitoringScreenState extends State<KepsekMonitoringScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kepsek = KepsekScope.of(context);
      final userId = SessionScope.of(context).user?.id;
      if (userId != null) kepsek.bindKepsek(userId);
      kepsek.loadAttendanceMonitoring();
      kepsek.loadScheduleMonitoring();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: AppColors.card,
          child: TabBar(
            controller: _tabs,
            labelColor: AppColors.navy,
            unselectedLabelColor: AppColors.muted,
            indicatorColor: AppColors.accent,
            labelStyle: AppText.style(size: 13.5, weight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Kehadiran'),
              Tab(text: 'Jadwal'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              _AttendanceTab(),
              _ScheduleTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab();

  @override
  Widget build(BuildContext context) {
    final kepsek = KepsekScope.of(context);
    final data = kepsek.attendanceMonitoring;

    if (kepsek.attendanceState == LoadState.loading ||
        kepsek.attendanceState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat monitoring kehadiran...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (kepsek.attendanceState == LoadState.error || data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kepsek.attendanceError ?? 'Gagal memuat data.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => kepsek.loadAttendanceMonitoring(),
                child: Text(
                  'Coba lagi',
                  style: AppText.style(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _FilterDropdown(
          label: 'Filter bulan',
          value: data.selectedMonth,
          options: data.monthOptions,
          onChanged: (value) => kepsek.loadAttendanceMonitoring(month: value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                label: 'Siswa',
                value: '${data.studentPresencePercent.toStringAsFixed(0)}%',
                hint: 'Kehadiran sekolah',
                color: AppColors.success,
                background: AppColors.successSoft,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatBox(
                label: 'Guru',
                value: '${data.teacherPresencePercent.toStringAsFixed(0)}%',
                hint: 'Kehadiran pegawai',
                color: AppColors.accent,
                background: AppColors.accentSoft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Grafik kehadiran mingguan'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: SimpleBarChart(points: data.weeklyChart),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Grafik kehadiran bulanan'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.border),
          ),
          child: SimpleBarChart(
            points: data.monthlyChart,
            barColor: AppColors.navyMid,
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Rekap kehadiran per kelas'),
        const SizedBox(height: 10),
        for (final item in data.classStats) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelas ${item.className}',
                        style: AppText.style(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        '${item.studentCount} siswa',
                        style: AppText.style(size: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${item.presentPercent.toStringAsFixed(0)}%',
                  style: AppText.style(
                    size: 16,
                    weight: FontWeight.w800,
                    color: item.presentPercent < 90
                        ? AppColors.danger
                        : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        const SectionHeader(title: 'Kehadiran guru hari ini'),
        const SizedBox(height: 10),
        for (final item in data.teacherStats) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppText.style(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      Text(
                        'Kehadiran ${item.presentPercent.toStringAsFixed(0)}%',
                        style: AppText.style(size: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                AttendanceStatusChip(status: item.statusToday),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  @override
  Widget build(BuildContext context) {
    final kepsek = KepsekScope.of(context);
    final data = kepsek.scheduleMonitoring;

    if (kepsek.scheduleState == LoadState.loading ||
        kepsek.scheduleState == LoadState.idle) {
      return Center(
        child: Text(
          'Memuat monitoring jadwal...',
          style: AppText.style(size: 13.5, color: AppColors.muted),
        ),
      );
    }

    if (kepsek.scheduleState == LoadState.error || data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kepsek.scheduleError ?? 'Gagal memuat jadwal.',
                textAlign: TextAlign.center,
                style: AppText.style(size: 14, color: AppColors.muted),
              ),
              TextButton(
                onPressed: () => kepsek.loadScheduleMonitoring(),
                child: Text(
                  'Coba lagi',
                  style: AppText.style(
                    size: 13.5,
                    weight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterDropdown(
                label: 'Kelas',
                value: data.selectedClass,
                options: data.classFilters,
                onChanged: (value) => kepsek.loadScheduleMonitoring(
                  classFilter: value,
                  teacherFilter: data.selectedTeacher,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FilterDropdown(
                label: 'Guru',
                value: data.selectedTeacher,
                options: data.teacherFilters,
                onChanged: (value) => kepsek.loadScheduleMonitoring(
                  classFilter: data.selectedClass,
                  teacherFilter: value,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Jadwal hari ini · ${data.dateLabel}',
          style: AppText.style(
            size: 14,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        if (data.items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Tidak ada jadwal untuk filter yang dipilih.',
              style: AppText.style(size: 13.5, color: AppColors.muted),
            ),
          )
        else
          for (final item in data.items) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subject,
                    style: AppText.style(
                      size: 15,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.start} – ${item.end} · Kelas ${item.className}',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                  Text(
                    '${item.teacher} · ${item.room}',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        const SizedBox(height: 8),
        Text(
          'Monitoring jadwal pembelajaran. Generate jadwal otomatis tidak tersedia di mobile.',
          style: AppText.style(size: 12, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.style(size: 11.5, color: AppColors.muted)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.navy,
              ),
              style: AppText.style(
                size: 13.5,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
              items: [
                for (final option in options)
                  DropdownMenuItem(value: option, child: Text(option)),
              ],
              onChanged: (selected) {
                if (selected != null) onChanged(selected);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.hint,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final String hint;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: AppText.style(
                size: 11,
                weight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppText.style(
              size: 26,
              weight: FontWeight.w800,
              color: AppColors.navy,
              height: 1.1,
            ),
          ),
          Text(hint, style: AppText.style(size: 12, color: AppColors.muted)),
        ],
      ),
    );
  }
}
