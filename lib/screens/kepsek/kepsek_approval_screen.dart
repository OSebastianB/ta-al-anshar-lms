import 'package:material_ui/material_ui.dart';

import '../../data/dummy_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class KepsekApprovalScreen extends StatefulWidget {
  const KepsekApprovalScreen({super.key});

  @override
  State<KepsekApprovalScreen> createState() => _KepsekApprovalScreenState();
}

class _KepsekApprovalScreenState extends State<KepsekApprovalScreen> {
  late final List<ScheduleApprovalItem> _items;

  @override
  void initState() {
    super.initState();
    _items = DummyData.createScheduleApprovals();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Persetujuan jadwal CSP',
          style: AppText.style(
            size: 18,
            weight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tinjau hasil generate dari Admin. CSP tidak dijalankan di mobile.',
          style: AppText.style(size: 13, color: AppColors.muted, height: 1.4),
        ),
        const SizedBox(height: 14),
        for (final item in _items) ...[
          _ApprovalCard(
            item: item,
            onOpen: () => _openDetail(item),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Future<void> _openDetail(ScheduleApprovalItem item) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => KepsekApprovalDetailScreen(
          item: item,
          onChanged: () => setState(() {}),
        ),
      ),
    );
    setState(() {});
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.item, required this.onOpen});

  final ScheduleApprovalItem item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: AppText.style(
                    size: 15,
                    weight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
              _StatusBadge(status: item.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${item.academicYear} · ${item.semester}',
            style: AppText.style(size: 12.5, color: AppColors.muted),
          ),
          Text(
            'Generate: ${item.generatedAt}',
            style: AppText.style(size: 12.5, color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(
            '${item.classCount} kelas · ${item.teacherCount} guru',
            style: AppText.style(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.navyMid,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.style(size: 12.5, color: AppColors.muted, height: 1.35),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.borderStrong),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onOpen,
              child: Text(
                'Lihat Detail',
                style: AppText.style(
                  weight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KepsekApprovalDetailScreen extends StatefulWidget {
  const KepsekApprovalDetailScreen({
    super.key,
    required this.item,
    required this.onChanged,
  });

  final ScheduleApprovalItem item;
  final VoidCallback onChanged;

  @override
  State<KepsekApprovalDetailScreen> createState() =>
      _KepsekApprovalDetailScreenState();
}

class _KepsekApprovalDetailScreenState
    extends State<KepsekApprovalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        surfaceTintColor: AppColors.card,
        elevation: 0,
        foregroundColor: AppColors.navy,
        title: Text(
          'Detail jadwal',
          style: AppText.style(
            size: 16,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.border),
        ),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Text(
            item.title,
            style: AppText.style(
              size: 20,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          _StatusBadge(status: item.status),
          const SizedBox(height: 14),
          _InfoRow(label: 'Tahun ajaran', value: item.academicYear),
          _InfoRow(label: 'Semester', value: item.semester),
          _InfoRow(label: 'Tanggal generate', value: item.generatedAt),
          _InfoRow(label: 'Jumlah kelas', value: '${item.classCount}'),
          _InfoRow(label: 'Jumlah guru', value: '${item.teacherCount}'),
          const SizedBox(height: 8),
          Text(
            'Ringkasan hasil penjadwalan',
            style: AppText.style(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.summary,
            style: AppText.style(size: 13.5, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Detail jadwal per kelas',
            style: AppText.style(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          for (final detail in item.details) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${detail.subject} · Kelas ${detail.className}',
                    style: AppText.style(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${detail.start} – ${detail.end}',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                  Text(
                    '${detail.teacher} · ${detail.room}',
                    style: AppText.style(size: 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          if (item.status != ScheduleApprovalStatus.disetujui) ...[
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _confirmApprove(item),
                child: Text(
                  'Setujui Jadwal',
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: Color(0xFFF3C1C1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _confirmRevise(item),
                child: Text(
                  'Kembalikan untuk Revisi',
                  style: AppText.style(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.successSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC5E8D3)),
              ),
              child: Text(
                'Jadwal ini sudah disetujui dan dipublikasikan.',
                style: AppText.style(
                  size: 13.5,
                  weight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmApprove(ScheduleApprovalItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Setujui jadwal?',
            style: AppText.style(
              size: 17,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          content: Text(
            'Jadwal akan ditandai Disetujui pada simulasi ini. Tidak ada data yang dikirim ke server.',
            style: AppText.style(size: 14, color: AppColors.text, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: AppText.style(weight: FontWeight.w700, color: AppColors.muted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Setujui',
                style: AppText.style(weight: FontWeight.w700, color: AppColors.success),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    setState(() => item.status = ScheduleApprovalStatus.disetujui);
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        content: Text(
          'Jadwal disetujui (simulasi).',
          style: AppText.style(size: 13, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _confirmRevise(ScheduleApprovalItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Kembalikan untuk revisi?',
            style: AppText.style(
              size: 17,
              weight: FontWeight.w800,
              color: AppColors.navy,
            ),
          ),
          content: Text(
            'Status jadwal akan menjadi Perlu Revisi. Admin dapat memperbaiki hasil generate di website.',
            style: AppText.style(size: 14, color: AppColors.text, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: AppText.style(weight: FontWeight.w700, color: AppColors.muted),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Kembalikan',
                style: AppText.style(weight: FontWeight.w700, color: AppColors.danger),
              ),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    setState(() => item.status = ScheduleApprovalStatus.revisi);
    widget.onChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        content: Text(
          'Jadwal dikembalikan untuk revisi (simulasi).',
          style: AppText.style(size: 13, color: Colors.white),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ScheduleApprovalStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: AppText.style(
          size: 11,
          weight: FontWeight.w700,
          color: status.color,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppText.style(size: 13, color: AppColors.muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppText.style(
                size: 13.5,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
