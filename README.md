# LMS Al-Anshar

Aplikasi Learning Management System berbasis Android untuk SD Islam Al-Anshar Kota Bekasi.

**Judul TA:** Pengembangan Aplikasi Learning Management System Berbasis Android Menggunakan Flutter pada SD Islam Al-Anshar Kota Bekasi.

## Role

| Role | Akses |
|------|--------|
| Guru | Dashboard, kelas, jadwal, absensi |
| Orang Tua | Dashboard anak, jadwal, kehadiran |
| Kepala Sekolah | Monitoring, laporan, persetujuan jadwal |

Admin memakai aplikasi web (di luar repo ini).

## Menjalankan

```bash
cd al_anshar_lms
flutter pub get
flutter run
```

```bash
flutter analyze
flutter test
```

## Akun demo

| Role | Username | Password |
|------|----------|----------|
| Guru | `ratna@alanshar.sch.id` | `demo` |
| Orang Tua | `ortu@alanshar.sch.id` | `demo` |
| Kepala Sekolah | `kepsek@alanshar.sch.id` | `demo` |

Chip role di login mengisi username saja. Role mengikuti hasil login.

## Catatan

Data masih memakai mock repository sampai API backend tersedia. Base URL bisa di-set lewat `--dart-define=API_BASE_URL=...`.
