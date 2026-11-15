import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

enum NoticeKind { sekolah, jadwal, absensi, akademik }

enum AttendanceStatus { hadir, izin, sakit, alpa }

class ScheduleItem {
  const ScheduleItem({
    required this.start,
    required this.end,
    required this.subject,
    required this.className,
    required this.room,
    this.teacher,
  });

  final String start;
  final String end;
  final String subject;
  final String className;
  final String room;
  final String? teacher;
}

class AnnouncementItem {
  const AnnouncementItem({
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.kind,
  });

  final String title;
  final String body;
  final String timeLabel;
  final NoticeKind kind;
}

class AppNotice {
  const AppNotice({
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.kind,
    this.unread = true,
  });

  final String title;
  final String body;
  final String timeLabel;
  final NoticeKind kind;
  final bool unread;
}

class AttendanceSlice {
  const AttendanceSlice({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
  });

  final String label;
  final int value;
  final Color color;
  final Color background;
}

class StudentItem {
  const StudentItem({
    required this.nis,
    required this.name,
    required this.initials,
    this.status = AttendanceStatus.hadir,
  });

  final String nis;
  final String name;
  final String initials;
  final AttendanceStatus status;
}

class ClassItem {
  const ClassItem({
    required this.name,
    required this.level,
    required this.studentCount,
    required this.homeroom,
    required this.preview,
  });

  final String name;
  final String level;
  final int studentCount;
  final String homeroom;
  final List<StudentItem> preview;
}

class AttendanceHistoryItem {
  const AttendanceHistoryItem({
    required this.dateLabel,
    required this.className,
    required this.subject,
    required this.present,
    required this.permission,
    required this.sick,
    required this.absent,
  });

  final String dateLabel;
  final String className;
  final String subject;
  final int present;
  final int permission;
  final int sick;
  final int absent;

  int get total => present + permission + sick + absent;

  double get presentRate => total == 0 ? 0 : present / total * 100;
}

class ChildAttendanceDay {
  const ChildAttendanceDay({
    required this.dateLabel,
    required this.dayLabel,
    required this.status,
    required this.note,
  });

  final String dateLabel;
  final String dayLabel;
  final AttendanceStatus status;
  final String note;
}

enum ScheduleApprovalStatus { menunggu, disetujui, revisi }

class ChartPoint {
  const ChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class ClassAttendanceStat {
  const ClassAttendanceStat({
    required this.className,
    required this.presentPercent,
    required this.studentCount,
  });

  final String className;
  final double presentPercent;
  final int studentCount;
}

class TeacherAttendanceStat {
  const TeacherAttendanceStat({
    required this.name,
    required this.presentPercent,
    required this.statusToday,
  });

  final String name;
  final double presentPercent;
  final AttendanceStatus statusToday;
}

class SchoolScheduleItem {
  const SchoolScheduleItem({
    required this.start,
    required this.end,
    required this.subject,
    required this.className,
    required this.teacher,
    required this.room,
  });

  final String start;
  final String end;
  final String subject;
  final String className;
  final String teacher;
  final String room;
}

class ScheduleApprovalItem {
  ScheduleApprovalItem({
    required this.id,
    required this.title,
    required this.academicYear,
    required this.semester,
    required this.generatedAt,
    required this.classCount,
    required this.teacherCount,
    required this.summary,
    required this.details,
    required this.status,
  });

  final String id;
  final String title;
  final String academicYear;
  final String semester;
  final String generatedAt;
  final int classCount;
  final int teacherCount;
  final String summary;
  final List<SchoolScheduleItem> details;
  ScheduleApprovalStatus status;
}

class SchoolAnnouncement {
  const SchoolAnnouncement({
    required this.id,
    required this.title,
    required this.body,
    required this.dateLabel,
    required this.author,
    this.published = true,
  });

  final String id;
  final String title;
  final String body;
  final String dateLabel;
  final String author;
  final bool published;
}

class WeekDay {
  const WeekDay({
    required this.key,
    required this.short,
    required this.label,
    required this.dateLabel,
  });

  final String key;
  final String short;
  final String label;
  final String dateLabel;
}

/// Data simulasi untuk presentasi. Tidak disimpan dan tidak diproses.
abstract final class DummyData {
  static const demoDateLabel = 'Senin, 16 Nov 2026';

  static const guruName = 'Bu Ratna Sari';
  static const guruRole = 'Guru Matematika';
  static const guruHomeroom = 'Wali Kelas V-A';
  static const guruInitials = 'RS';
  static const guruEmail = 'ratna.sari@alanshar.sch.id';
  static const guruPhone = '0812-3456-7890';

  static const parentName = 'Ibu Siti Ramadhani';
  static const parentInitials = 'SR';
  static const parentEmail = 'siti.ramadhani@gmail.com';
  static const parentPhone = '0813-9876-5432';
  static const childName = 'Aulia Zahra Ramadhani';
  static const childClass = 'Kelas V-A';
  static const childNis = '2024510001';
  static const childInitials = 'AZ';

  static const weekDays = <WeekDay>[
    WeekDay(key: 'senin', short: 'Sen', label: 'Senin', dateLabel: '16 Nov'),
    WeekDay(key: 'selasa', short: 'Sel', label: 'Selasa', dateLabel: '17 Nov'),
    WeekDay(key: 'rabu', short: 'Rab', label: 'Rabu', dateLabel: '18 Nov'),
    WeekDay(key: 'kamis', short: 'Kam', label: 'Kamis', dateLabel: '19 Nov'),
    WeekDay(key: 'jumat', short: 'Jum', label: 'Jumat', dateLabel: '20 Nov'),
  ];

  static const todaySchedule = <ScheduleItem>[
    ScheduleItem(
      start: '07.35',
      end: '08.10',
      subject: 'Matematika',
      className: 'V-A',
      room: 'Ruang 5A',
    ),
    ScheduleItem(
      start: '08.10',
      end: '08.45',
      subject: 'Matematika',
      className: 'V-A',
      room: 'Ruang 5A',
    ),
    ScheduleItem(
      start: '09.00',
      end: '09.35',
      subject: 'Matematika',
      className: 'IV-B',
      room: 'Ruang 4B',
    ),
    ScheduleItem(
      start: '10.10',
      end: '10.45',
      subject: 'Matematika',
      className: 'VI-A',
      room: 'Ruang 6A',
    ),
  ];

  static const guruWeeklySchedule = <String, List<ScheduleItem>>{
    'senin': todaySchedule,
    'selasa': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
      ),
      ScheduleItem(
        start: '09.00',
        end: '09.35',
        subject: 'Matematika',
        className: 'IV-B',
        room: 'Ruang 4B',
      ),
      ScheduleItem(
        start: '10.10',
        end: '10.45',
        subject: 'Matematika',
        className: 'VI-A',
        room: 'Ruang 6A',
      ),
    ],
    'rabu': [
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
      ),
      ScheduleItem(
        start: '09.35',
        end: '10.10',
        subject: 'Matematika',
        className: 'IV-B',
        room: 'Ruang 4B',
      ),
    ],
    'kamis': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'VI-A',
        room: 'Ruang 6A',
      ),
      ScheduleItem(
        start: '09.00',
        end: '09.35',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
      ),
      ScheduleItem(
        start: '10.10',
        end: '10.45',
        subject: 'Matematika',
        className: 'IV-B',
        room: 'Ruang 4B',
      ),
    ],
    'jumat': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
      ),
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Matematika',
        className: 'VI-A',
        room: 'Ruang 6A',
      ),
    ],
  };

  static const childWeeklySchedule = <String, List<ScheduleItem>>{
    'senin': [
      ScheduleItem(
        start: '07.00',
        end: '07.35',
        subject: 'Pendidikan Agama Islam',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Pak Yusuf Hakim',
      ),
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '09.00',
        end: '09.35',
        subject: 'Bahasa Indonesia',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Lestari Aminah',
      ),
      ScheduleItem(
        start: '09.35',
        end: '10.10',
        subject: 'IPA',
        className: 'V-A',
        room: 'Lab IPA',
        teacher: 'Pak Hendra Wijaya',
      ),
    ],
    'selasa': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Bahasa Inggris',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Nadia Putri',
      ),
      ScheduleItem(
        start: '09.00',
        end: '09.35',
        subject: 'IPS',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Pak Andi Saputra',
      ),
    ],
    'rabu': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Bahasa Indonesia',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Lestari Aminah',
      ),
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '09.35',
        end: '10.10',
        subject: 'Seni Budaya',
        className: 'V-A',
        room: 'Aula',
        teacher: 'Bu Maya Kartika',
      ),
    ],
    'kamis': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'IPA',
        className: 'V-A',
        room: 'Lab IPA',
        teacher: 'Pak Hendra Wijaya',
      ),
      ScheduleItem(
        start: '09.00',
        end: '09.35',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '10.10',
        end: '10.45',
        subject: 'PJOK',
        className: 'V-A',
        room: 'Lapangan',
        teacher: 'Pak Budi Santoso',
      ),
    ],
    'jumat': [
      ScheduleItem(
        start: '07.35',
        end: '08.10',
        subject: 'Matematika',
        className: 'V-A',
        room: 'Ruang 5A',
        teacher: 'Bu Ratna Sari',
      ),
      ScheduleItem(
        start: '08.10',
        end: '08.45',
        subject: 'Pendidikan Agama Islam',
        className: 'V-A',
        room: 'Masjid',
        teacher: 'Pak Yusuf Hakim',
      ),
    ],
  };

  static const studentsVa = <StudentItem>[
    StudentItem(nis: '2024510001', name: 'Aulia Zahra Ramadhani', initials: 'AZ'),
    StudentItem(nis: '2024510002', name: 'Bagas Pratama', initials: 'BP'),
    StudentItem(nis: '2024510003', name: 'Citra Melati', initials: 'CM'),
    StudentItem(nis: '2024510004', name: 'Dimas Arya', initials: 'DA'),
    StudentItem(nis: '2024510005', name: 'Eka Putri', initials: 'EP'),
    StudentItem(
      nis: '2024510006',
      name: 'Farhan Akbar',
      initials: 'FA',
      status: AttendanceStatus.alpa,
    ),
    StudentItem(nis: '2024510007', name: 'Gita Safira', initials: 'GS'),
    StudentItem(
      nis: '2024510008',
      name: 'Hafiz Rahman',
      initials: 'HR',
      status: AttendanceStatus.izin,
    ),
    StudentItem(nis: '2024510009', name: 'Indira Ayu', initials: 'IA'),
    StudentItem(
      nis: '2024510010',
      name: 'Joko Nugroho',
      initials: 'JN',
      status: AttendanceStatus.sakit,
    ),
    StudentItem(nis: '2024510011', name: 'Kirana Dewi', initials: 'KD'),
    StudentItem(nis: '2024510012', name: 'Lutfi Hakim', initials: 'LH'),
  ];

  static const classes = <ClassItem>[
    ClassItem(
      name: 'V-A',
      level: 'Kelas 5',
      studentCount: 32,
      homeroom: 'Bu Ratna Sari',
      preview: studentsVa,
    ),
    ClassItem(
      name: 'IV-B',
      level: 'Kelas 4',
      studentCount: 30,
      homeroom: 'Bu Lestari Aminah',
      preview: [
        StudentItem(nis: '2024410001', name: 'Nabila Putri', initials: 'NP'),
        StudentItem(nis: '2024410002', name: 'Omar Fauzan', initials: 'OF'),
        StudentItem(nis: '2024410003', name: 'Putri Anggraini', initials: 'PA'),
        StudentItem(nis: '2024410004', name: 'Raka Wijaya', initials: 'RW'),
      ],
    ),
    ClassItem(
      name: 'VI-A',
      level: 'Kelas 6',
      studentCount: 28,
      homeroom: 'Pak Hendra Wijaya',
      preview: [
        StudentItem(nis: '2024310001', name: 'Salma Nur', initials: 'SN'),
        StudentItem(nis: '2024310002', name: 'Taufik Hidayat', initials: 'TH'),
        StudentItem(nis: '2024310003', name: 'Umi Kalsum', initials: 'UK'),
        StudentItem(nis: '2024310004', name: 'Vino Aditya', initials: 'VA'),
      ],
    ),
  ];

  static const classOptions = ['V-A', 'IV-B', 'VI-A'];
  static const subjectOptions = ['Matematika', 'IPA', 'Bahasa Indonesia'];
  static const monthFilters = [
    'November 2026',
    'Oktober 2026',
    'September 2026',
  ];

  static const attendance = <AttendanceSlice>[
    AttendanceSlice(
      label: 'Hadir',
      value: 29,
      color: AppColors.success,
      background: AppColors.successSoft,
    ),
    AttendanceSlice(
      label: 'Izin',
      value: 1,
      color: AppColors.warningInk,
      background: AppColors.warningSoft,
    ),
    AttendanceSlice(
      label: 'Sakit',
      value: 1,
      color: AppColors.purple,
      background: AppColors.purpleSoft,
    ),
    AttendanceSlice(
      label: 'Alpa',
      value: 1,
      color: AppColors.danger,
      background: AppColors.dangerSoft,
    ),
  ];

  static const attendanceHistory = <AttendanceHistoryItem>[
    AttendanceHistoryItem(
      dateLabel: 'Senin, 16 Nov 2026',
      className: 'V-A',
      subject: 'Matematika',
      present: 29,
      permission: 1,
      sick: 1,
      absent: 1,
    ),
    AttendanceHistoryItem(
      dateLabel: 'Jumat, 13 Nov 2026',
      className: 'V-A',
      subject: 'Matematika',
      present: 30,
      permission: 1,
      sick: 1,
      absent: 0,
    ),
    AttendanceHistoryItem(
      dateLabel: 'Kamis, 12 Nov 2026',
      className: 'IV-B',
      subject: 'Matematika',
      present: 28,
      permission: 1,
      sick: 0,
      absent: 1,
    ),
    AttendanceHistoryItem(
      dateLabel: 'Rabu, 11 Nov 2026',
      className: 'VI-A',
      subject: 'Matematika',
      present: 27,
      permission: 0,
      sick: 1,
      absent: 0,
    ),
    AttendanceHistoryItem(
      dateLabel: 'Selasa, 10 Nov 2026',
      className: 'V-A',
      subject: 'Matematika',
      present: 31,
      permission: 0,
      sick: 0,
      absent: 1,
    ),
  ];

  static const childAttendanceMonth = <AttendanceSlice>[
    AttendanceSlice(
      label: 'Hadir',
      value: 18,
      color: AppColors.success,
      background: AppColors.successSoft,
    ),
    AttendanceSlice(
      label: 'Izin',
      value: 1,
      color: AppColors.warningInk,
      background: AppColors.warningSoft,
    ),
    AttendanceSlice(
      label: 'Sakit',
      value: 1,
      color: AppColors.purple,
      background: AppColors.purpleSoft,
    ),
    AttendanceSlice(
      label: 'Alpa',
      value: 0,
      color: AppColors.danger,
      background: AppColors.dangerSoft,
    ),
  ];

  static const childAttendanceDays = <ChildAttendanceDay>[
    ChildAttendanceDay(
      dateLabel: '16 Nov 2026',
      dayLabel: 'Senin',
      status: AttendanceStatus.hadir,
      note: 'Hadir tepat waktu',
    ),
    ChildAttendanceDay(
      dateLabel: '13 Nov 2026',
      dayLabel: 'Jumat',
      status: AttendanceStatus.hadir,
      note: 'Hadir tepat waktu',
    ),
    ChildAttendanceDay(
      dateLabel: '12 Nov 2026',
      dayLabel: 'Kamis',
      status: AttendanceStatus.izin,
      note: 'Izin keperluan keluarga',
    ),
    ChildAttendanceDay(
      dateLabel: '11 Nov 2026',
      dayLabel: 'Rabu',
      status: AttendanceStatus.hadir,
      note: 'Hadir tepat waktu',
    ),
    ChildAttendanceDay(
      dateLabel: '10 Nov 2026',
      dayLabel: 'Selasa',
      status: AttendanceStatus.sakit,
      note: 'Sakit demam',
    ),
    ChildAttendanceDay(
      dateLabel: '09 Nov 2026',
      dayLabel: 'Senin',
      status: AttendanceStatus.hadir,
      note: 'Hadir tepat waktu',
    ),
  ];

  static const announcements = <AnnouncementItem>[
    AnnouncementItem(
      title: 'Rapat wali kelas',
      body:
          'Rapat koordinasi wali kelas dilaksanakan hari ini pukul 13.00 di ruang guru.',
      timeLabel: 'Hari ini · 06.40',
      kind: NoticeKind.sekolah,
    ),
    AnnouncementItem(
      title: 'Pengumpulan nilai PTS',
      body:
          'Nilai Penilaian Tengah Semester dikumpulkan paling lambat Jumat, 20 November 2026.',
      timeLabel: 'Kemarin · 15.10',
      kind: NoticeKind.akademik,
    ),
  ];

  static const parentAnnouncements = <AnnouncementItem>[
    AnnouncementItem(
      title: 'Pembagian rapor tengah semester',
      body:
          'Rapor PTS dibagikan Sabtu, 21 November 2026 pukul 08.00 di aula sekolah.',
      timeLabel: 'Hari ini · 07.00',
      kind: NoticeKind.sekolah,
    ),
    AnnouncementItem(
      title: 'Jadwal try out kelas V',
      body: 'Try out Matematika dan IPA dilaksanakan Senin depan pukul 08.00.',
      timeLabel: 'Kemarin · 16.20',
      kind: NoticeKind.akademik,
    ),
  ];

  static const notices = <AppNotice>[
    AppNotice(
      title: 'Rapat wali kelas pukul 13.00',
      body: 'Ruang guru · harap membawa rekap kehadiran minggu ini.',
      timeLabel: '06.40',
      kind: NoticeKind.sekolah,
    ),
    AppNotice(
      title: 'Perubahan jam IPA kelas VI-A',
      body: 'Sesi IPA dipindah ke Rabu, jam ke-2. Ruang tetap 6A.',
      timeLabel: 'Kemarin',
      kind: NoticeKind.jadwal,
    ),
    AppNotice(
      title: '1 siswa V-A belum hadir',
      body: 'Farhan Akbar tercatat alpa pada apel pagi.',
      timeLabel: '07.20',
      kind: NoticeKind.absensi,
    ),
    AppNotice(
      title: 'Batas input nilai PTS',
      body: 'Pengumpulan nilai paling lambat 20 November 2026.',
      timeLabel: '15 Nov',
      kind: NoticeKind.akademik,
      unread: false,
    ),
  ];

  static const parentNotices = <AppNotice>[
    AppNotice(
      title: 'Aulia hadir hari ini',
      body: 'Status kehadiran Aulia Zahra tercatat Hadir pukul 06.55.',
      timeLabel: '06.55',
      kind: NoticeKind.absensi,
    ),
    AppNotice(
      title: 'Perubahan jadwal IPA',
      body: 'IPA kelas V-A dipindah ke Rabu jam ke-3 di Lab IPA.',
      timeLabel: 'Kemarin',
      kind: NoticeKind.jadwal,
    ),
    AppNotice(
      title: 'Pembagian rapor PTS',
      body: 'Orang tua diminta hadir Sabtu, 21 November 2026 pukul 08.00.',
      timeLabel: '15 Nov',
      kind: NoticeKind.sekolah,
    ),
    AppNotice(
      title: 'Pengingat PR Matematika',
      body: 'Latihan pecahan senilai dikumpulkan Senin depan.',
      timeLabel: '14 Nov',
      kind: NoticeKind.akademik,
      unread: false,
    ),
  ];

  static int get unreadCount => notices.where((item) => item.unread).length;

  static int get parentUnreadCount =>
      parentNotices.where((item) => item.unread).length;

  static double get childPresentPercent {
    final total = childAttendanceMonth.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return 0;
    return childAttendanceMonth.first.value / total * 100;
  }

  static double get classPresentPercent {
    final total = attendance.fold<int>(0, (sum, item) => sum + item.value);
    if (total == 0) return 0;
    return attendance.first.value / total * 100;
  }

  // ——— Kepala Sekolah ———
  static const kepsekName = 'Pak Hidayat Rahman';
  static const kepsekRole = 'Kepala Sekolah';
  static const kepsekInitials = 'HR';
  static const kepsekEmail = 'hidayat.rahman@alanshar.sch.id';
  static const kepsekPhone = '0812-7788-9900';

  static const totalStudents = 312;
  static const totalTeachers = 24;
  static const totalClasses = 12;
  static const studentPresencePercent = 94.0;
  static const teacherPresencePercent = 97.0;

  static const kepsekNotices = <AppNotice>[
    AppNotice(
      title: 'Jadwal semester genap menunggu persetujuan',
      body: 'Hasil generate CSP dari Admin siap ditinjau.',
      timeLabel: '07.05',
      kind: NoticeKind.jadwal,
    ),
    AppNotice(
      title: 'Kehadiran siswa di bawah 90%',
      body: 'Kelas IV-B tercatat 88% hadir minggu ini.',
      timeLabel: 'Kemarin',
      kind: NoticeKind.absensi,
    ),
    AppNotice(
      title: 'Rapat koordinasi kurikulum',
      body: 'Rapat Senin pukul 13.00 di ruang kepala sekolah.',
      timeLabel: '15 Nov',
      kind: NoticeKind.sekolah,
    ),
    AppNotice(
      title: 'Laporan PTS siap ditinjau',
      body: 'Rekap nilai dan kehadiran PTS sudah diunggah Admin.',
      timeLabel: '14 Nov',
      kind: NoticeKind.akademik,
      unread: false,
    ),
  ];

  static int get kepsekUnreadCount =>
      kepsekNotices.where((item) => item.unread).length;

  static const schoolActivities = <AnnouncementItem>[
    AnnouncementItem(
      title: 'Apel pagi berjalan lancar',
      body: '312 siswa hadir pada apel pagi hari ini.',
      timeLabel: 'Hari ini · 07.00',
      kind: NoticeKind.sekolah,
    ),
    AnnouncementItem(
      title: 'Pengumpulan nilai PTS',
      body: '18 dari 24 guru sudah mengunggah nilai PTS.',
      timeLabel: 'Kemarin · 16.00',
      kind: NoticeKind.akademik,
    ),
  ];

  static const todaySchoolSchedule = <SchoolScheduleItem>[
    SchoolScheduleItem(
      start: '07.35',
      end: '08.10',
      subject: 'Matematika',
      className: 'V-A',
      teacher: 'Bu Ratna Sari',
      room: 'Ruang 5A',
    ),
    SchoolScheduleItem(
      start: '07.35',
      end: '08.10',
      subject: 'Bahasa Indonesia',
      className: 'IV-B',
      teacher: 'Bu Lestari Aminah',
      room: 'Ruang 4B',
    ),
    SchoolScheduleItem(
      start: '08.10',
      end: '08.45',
      subject: 'IPA',
      className: 'VI-A',
      teacher: 'Pak Hendra Wijaya',
      room: 'Lab IPA',
    ),
    SchoolScheduleItem(
      start: '09.00',
      end: '09.35',
      subject: 'Pendidikan Agama Islam',
      className: 'V-A',
      teacher: 'Pak Yusuf Hakim',
      room: 'Ruang 5A',
    ),
  ];

  static const weeklyPresenceChart = <ChartPoint>[
    ChartPoint(label: 'Sen', value: 95),
    ChartPoint(label: 'Sel', value: 93),
    ChartPoint(label: 'Rab', value: 96),
    ChartPoint(label: 'Kam', value: 92),
    ChartPoint(label: 'Jum', value: 94),
  ];

  static const monthlyPresenceChart = <ChartPoint>[
    ChartPoint(label: 'Jul', value: 91),
    ChartPoint(label: 'Agu', value: 93),
    ChartPoint(label: 'Sep', value: 94),
    ChartPoint(label: 'Okt', value: 92),
    ChartPoint(label: 'Nov', value: 94),
  ];

  static const classAttendanceStats = <ClassAttendanceStat>[
    ClassAttendanceStat(className: 'I-A', presentPercent: 96, studentCount: 28),
    ClassAttendanceStat(className: 'II-A', presentPercent: 95, studentCount: 27),
    ClassAttendanceStat(className: 'III-A', presentPercent: 93, studentCount: 26),
    ClassAttendanceStat(className: 'IV-A', presentPercent: 94, studentCount: 29),
    ClassAttendanceStat(className: 'IV-B', presentPercent: 88, studentCount: 30),
    ClassAttendanceStat(className: 'V-A', presentPercent: 91, studentCount: 32),
    ClassAttendanceStat(className: 'VI-A', presentPercent: 97, studentCount: 28),
  ];

  static const teacherAttendanceStats = <TeacherAttendanceStat>[
    TeacherAttendanceStat(
      name: 'Bu Ratna Sari',
      presentPercent: 98,
      statusToday: AttendanceStatus.hadir,
    ),
    TeacherAttendanceStat(
      name: 'Pak Hendra Wijaya',
      presentPercent: 96,
      statusToday: AttendanceStatus.hadir,
    ),
    TeacherAttendanceStat(
      name: 'Bu Lestari Aminah',
      presentPercent: 94,
      statusToday: AttendanceStatus.izin,
    ),
    TeacherAttendanceStat(
      name: 'Pak Yusuf Hakim',
      presentPercent: 99,
      statusToday: AttendanceStatus.hadir,
    ),
    TeacherAttendanceStat(
      name: 'Bu Nadia Putri',
      presentPercent: 95,
      statusToday: AttendanceStatus.hadir,
    ),
  ];

  static const schoolTeacherFilters = <String>[
    'Semua guru',
    'Bu Ratna Sari',
    'Pak Hendra Wijaya',
    'Bu Lestari Aminah',
    'Pak Yusuf Hakim',
  ];

  static const schoolClassFilters = <String>[
    'Semua kelas',
    'IV-B',
    'V-A',
    'VI-A',
  ];

  static List<ScheduleApprovalItem> createScheduleApprovals() {
    return [
      ScheduleApprovalItem(
        id: 'csp-1',
        title: 'Generate Jadwal Semester Genap',
        academicYear: '2026/2027',
        semester: 'Semester Genap',
        generatedAt: '14 Nov 2026 · 21.40',
        classCount: 12,
        teacherCount: 24,
        summary:
            'Penjadwalan otomatis selesai tanpa bentrok jam guru. 3 kelas mendapat penyesuaian ruangan.',
        status: ScheduleApprovalStatus.menunggu,
        details: const [
          SchoolScheduleItem(
            start: '07.35',
            end: '08.10',
            subject: 'Matematika',
            className: 'V-A',
            teacher: 'Bu Ratna Sari',
            room: 'Ruang 5A',
          ),
          SchoolScheduleItem(
            start: '08.10',
            end: '08.45',
            subject: 'IPA',
            className: 'V-A',
            teacher: 'Pak Hendra Wijaya',
            room: 'Lab IPA',
          ),
          SchoolScheduleItem(
            start: '07.35',
            end: '08.10',
            subject: 'Bahasa Indonesia',
            className: 'IV-B',
            teacher: 'Bu Lestari Aminah',
            room: 'Ruang 4B',
          ),
          SchoolScheduleItem(
            start: '09.00',
            end: '09.35',
            subject: 'Matematika',
            className: 'VI-A',
            teacher: 'Bu Ratna Sari',
            room: 'Ruang 6A',
          ),
        ],
      ),
      ScheduleApprovalItem(
        id: 'csp-2',
        title: 'Revisi Jadwal Minggu Ujian',
        academicYear: '2026/2027',
        semester: 'Semester Ganjil',
        generatedAt: '10 Nov 2026 · 18.15',
        classCount: 12,
        teacherCount: 24,
        summary:
            'Jadwal ujian tengah semester. Menunggu penyesuaian ruang aula.',
        status: ScheduleApprovalStatus.revisi,
        details: const [
          SchoolScheduleItem(
            start: '08.00',
            end: '09.30',
            subject: 'Ujian Matematika',
            className: 'V-A',
            teacher: 'Bu Ratna Sari',
            room: 'Aula',
          ),
          SchoolScheduleItem(
            start: '08.00',
            end: '09.30',
            subject: 'Ujian IPA',
            className: 'VI-A',
            teacher: 'Pak Hendra Wijaya',
            room: 'Aula',
          ),
        ],
      ),
      ScheduleApprovalItem(
        id: 'csp-3',
        title: 'Jadwal Semester Ganjil',
        academicYear: '2026/2027',
        semester: 'Semester Ganjil',
        generatedAt: '02 Jul 2026 · 09.20',
        classCount: 12,
        teacherCount: 24,
        summary: 'Sudah disetujui dan dipublikasikan ke seluruh guru.',
        status: ScheduleApprovalStatus.disetujui,
        details: const [
          SchoolScheduleItem(
            start: '07.35',
            end: '08.10',
            subject: 'Matematika',
            className: 'V-A',
            teacher: 'Bu Ratna Sari',
            room: 'Ruang 5A',
          ),
        ],
      ),
    ];
  }

  static final schoolAnnouncements = <SchoolAnnouncement>[
    const SchoolAnnouncement(
      id: 'a1',
      title: 'Pembagian rapor PTS',
      body:
          'Pembagian rapor PTS dilaksanakan Sabtu, 21 November 2026 pukul 08.00 di aula sekolah. Orang tua diharapkan hadir.',
      dateLabel: '15 Nov 2026',
      author: 'Pak Hidayat Rahman',
    ),
    const SchoolAnnouncement(
      id: 'a2',
      title: 'Libur Maulid Nabi',
      body:
          'Kegiatan belajar mengajar diliburkan pada 15 September 2026 dalam rangka peringatan Maulid Nabi Muhammad SAW.',
      dateLabel: '08 Sep 2026',
      author: 'Pak Hidayat Rahman',
    ),
    const SchoolAnnouncement(
      id: 'a3',
      title: 'Draft: Latihan manasik haji',
      body:
          'Rencana kegiatan manasik haji untuk kelas VI. Belum dipublikasikan.',
      dateLabel: '16 Nov 2026',
      author: 'Pak Hidayat Rahman',
      published: false,
    ),
  ];
}

extension ScheduleApprovalStatusStyle on ScheduleApprovalStatus {
  String get label {
    switch (this) {
      case ScheduleApprovalStatus.menunggu:
        return 'Menunggu Persetujuan';
      case ScheduleApprovalStatus.disetujui:
        return 'Disetujui';
      case ScheduleApprovalStatus.revisi:
        return 'Perlu Revisi';
    }
  }

  Color get color {
    switch (this) {
      case ScheduleApprovalStatus.menunggu:
        return AppColors.warningInk;
      case ScheduleApprovalStatus.disetujui:
        return AppColors.success;
      case ScheduleApprovalStatus.revisi:
        return AppColors.danger;
    }
  }

  Color get background {
    switch (this) {
      case ScheduleApprovalStatus.menunggu:
        return AppColors.warningSoft;
      case ScheduleApprovalStatus.disetujui:
        return AppColors.successSoft;
      case ScheduleApprovalStatus.revisi:
        return AppColors.dangerSoft;
    }
  }
}

extension AttendanceStatusStyle on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.hadir:
        return 'Hadir';
      case AttendanceStatus.izin:
        return 'Izin';
      case AttendanceStatus.sakit:
        return 'Sakit';
      case AttendanceStatus.alpa:
        return 'Alpa';
    }
  }

  Color get color {
    switch (this) {
      case AttendanceStatus.hadir:
        return AppColors.success;
      case AttendanceStatus.izin:
        return AppColors.warningInk;
      case AttendanceStatus.sakit:
        return AppColors.purple;
      case AttendanceStatus.alpa:
        return AppColors.danger;
    }
  }

  Color get background {
    switch (this) {
      case AttendanceStatus.hadir:
        return AppColors.successSoft;
      case AttendanceStatus.izin:
        return AppColors.warningSoft;
      case AttendanceStatus.sakit:
        return AppColors.purpleSoft;
      case AttendanceStatus.alpa:
        return AppColors.dangerSoft;
    }
  }

  IconData get icon {
    switch (this) {
      case AttendanceStatus.hadir:
        return Icons.check_circle_outline;
      case AttendanceStatus.izin:
        return Icons.event_busy_outlined;
      case AttendanceStatus.sakit:
        return Icons.local_hospital_outlined;
      case AttendanceStatus.alpa:
        return Icons.cancel_outlined;
    }
  }
}

extension NoticeKindLabel on NoticeKind {
  String get label {
    switch (this) {
      case NoticeKind.sekolah:
        return 'Informasi sekolah';
      case NoticeKind.jadwal:
        return 'Perubahan jadwal';
      case NoticeKind.absensi:
        return 'Ketidakhadiran';
      case NoticeKind.akademik:
        return 'Pengumuman akademik';
    }
  }

  IconData get icon {
    switch (this) {
      case NoticeKind.sekolah:
        return Icons.campaign_outlined;
      case NoticeKind.jadwal:
        return Icons.event_repeat_outlined;
      case NoticeKind.absensi:
        return Icons.person_off_outlined;
      case NoticeKind.akademik:
        return Icons.menu_book_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NoticeKind.sekolah:
        return AppColors.accent;
      case NoticeKind.jadwal:
        return AppColors.warningInk;
      case NoticeKind.absensi:
        return AppColors.danger;
      case NoticeKind.akademik:
        return AppColors.purple;
    }
  }

  Color get background {
    switch (this) {
      case NoticeKind.sekolah:
        return AppColors.accentSoft;
      case NoticeKind.jadwal:
        return AppColors.warningSoft;
      case NoticeKind.absensi:
        return AppColors.dangerSoft;
      case NoticeKind.akademik:
        return AppColors.purpleSoft;
    }
  }
}
