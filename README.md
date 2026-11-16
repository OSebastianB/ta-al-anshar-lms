# LMS Al-Anshar (Flutter Android)

Aplikasi Learning Management System berbasis Android untuk **SD Islam Al-Anshar Kota Bekasi**.

**Judul TA:** Pengembangan Aplikasi Learning Management System Berbasis Android Menggunakan Flutter pada SD Islam Al-Anshar Kota Bekasi.

## Role pengguna

| Role | Akses utama |
|------|-------------|
| Guru | Dashboard, kelas/siswa, jadwal mengajar, absensi & riwayat |
| Orang Tua | Dashboard, info anak terhubung, jadwal & kehadiran anak |
| Kepala Sekolah | Dashboard monitoring, kehadiran/jadwal sekolah, rekap, laporan, persetujuan jadwal |

Admin sekolah memakai aplikasi web (di luar repo mobile ini).

## Stack

- Flutter + Dart
- Android
- State: `ChangeNotifier` + scope (`SessionScope`, `GuruScope`, dll.)
- Data sementara: **mock repository** (siap diganti REST API)
- Backend/database: dikerjakan tim lain (belum diintegrasikan)

## Struktur folder

```
al_anshar_lms/
├── android/                 # Proyek Android native
├── assets/                  # Logo & font
├── lib/
│   ├── core/                # Config, error, storage sesi
│   ├── data/                # Seed/mock data (DummyData)
│   ├── models/              # Model domain & DTO
│   ├── repositories/        # Interface + mock repository
│   ├── services/            # AuthService & layanan lain
│   ├── state/               # Session & controller per role
│   ├── theme/               # Warna & tipografi
│   ├── widgets/             # Komponen UI reusable
│   ├── screens/             # Halaman per role
│   │   ├── login/
│   │   ├── guru/
│   │   ├── orangtua/
│   │   ├── kepsek/
│   │   └── common/
│   ├── app.dart
│   └── main.dart
├── test/                    # Widget/integration test
├── pubspec.yaml
└── README.md
```

## Akun demo (mock auth)

| Role | Username | Password |
|------|----------|----------|
| Guru | `ratna@alanshar.sch.id` | `demo` |
| Orang Tua | `ortu@alanshar.sch.id` | `demo` |
| Kepala Sekolah | `kepsek@alanshar.sch.id` | `demo` |

Chip role di login hanya mengisi akun demo. Role aktual mengikuti hasil autentikasi.

## Menjalankan aplikasi

```bash
cd al_anshar_lms
flutter pub get
flutter devices
flutter run
```

Target utama: **Android** (emulator atau perangkat fisik).

```bash
flutter analyze
flutter test
```

## Integrasi API nanti

1. Implementasi repository remote (HTTP) mengikuti interface yang ada.
2. Set base URL lewat `--dart-define=API_BASE_URL=...`.
3. Matikan mock auth bila backend siap (`USE_MOCK_AUTH=false` jika dipakai).
4. Jangan mengarang skema database di sisi mobile; ikuti kontrak API tim backend.
