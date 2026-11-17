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

## Panduan pengembang

### Struktur `lib/`

| Folder | Isi |
|--------|-----|
| `core/` | Konfigurasi (`AppConfig`), exception, keamanan, penyimpanan sesi |
| `models/` | Model data per role |
| `repositories/` | Kontrak data (`*_repository.dart`) + implementasi mock (`mock_*.dart`) |
| `services/` | `AuthService`: login/logout + penyimpanan sesi |
| `state/` | Controller per role (`ChangeNotifier`) + `AsyncRunner` |
| `screens/` | Layar per role; `*_shell.dart` = halaman utama berisi tab |
| `widgets/` | Komponen UI bersama, termasuk `RoleScaffold` |

### Alur data

```
Screen -> XxxScope.of(context) -> XxxController -> XxxRepository (mock / API)
```

- Layar hanya membaca field controller (`dashboard`, `dashboardState`, `dashboardError`) dan memanggil method `loadXxx()`.
- Controller memakai `runLoad` / `runAction` dari `AsyncRunner` untuk loading, error, dan status kosong.
- Role ditentukan dari akun yang login, lalu `_AuthGate` di `app.dart` membuka shell yang sesuai.

### Menambah tab baru

1. Buat layar di `screens/<role>/`.
2. Tambahkan `RoleTab` di `*_shell.dart` role tersebut.
3. Jika butuh data baru: tambah method di kontrak repository, implementasikan di mock, lalu tambah `loadXxx()` di controller.

### Mengganti mock ke API

1. Buat kelas baru yang `implements` kontrak repository (mis. `ApiGuruRepository`).
2. Lempar `DataException` / `AuthException` berisi pesan untuk pengguna.
3. Masukkan ke `LmsApp(...)` di `main.dart`. Layar dan controller tidak perlu diubah.
4. Set base URL dengan `--dart-define=API_BASE_URL=...`.
