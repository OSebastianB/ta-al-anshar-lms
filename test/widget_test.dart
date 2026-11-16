import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:al_anshar_lms/app.dart';
import 'package:al_anshar_lms/core/storage/memory_session_storage.dart';
import 'package:al_anshar_lms/repositories/mock_auth_repository.dart';
import 'package:al_anshar_lms/repositories/mock_guru_repository.dart';
import 'package:al_anshar_lms/repositories/mock_kepsek_repository.dart';
import 'package:al_anshar_lms/repositories/mock_parent_repository.dart';

void main() {
  Widget buildApp() {
    return LmsApp(
      authRepository: MockAuthRepository(networkDelay: Duration.zero),
      sessionStorage: MemorySessionStorage(),
      guruRepository: MockGuruRepository(networkDelay: Duration.zero),
      parentRepository: MockParentRepository(networkDelay: Duration.zero),
      kepsekRepository: MockKepsekRepository(networkDelay: Duration.zero),
    );
  }

  Future<void> pumpPhone(WidgetTester tester, Widget app) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
  }

  Future<void> loginAs(
    WidgetTester tester, {
    required String roleLabel,
    required String username,
    required String password,
  }) async {
    if (roleLabel != 'Guru') {
      await tester.tap(find.text(roleLabel));
      await tester.pump();
    }
    await tester.enterText(find.byType(TextField).at(0), username);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();
  }

  testWidgets('Halaman login menampilkan identitas sekolah', (tester) async {
    await pumpPhone(tester, buildApp());

    expect(find.text('Masuk ke Sistem'), findsOneWidget);
    expect(find.text('Al-Anshar'), findsOneWidget);
    expect(find.text('Guru'), findsOneWidget);
    expect(find.text('Orang Tua'), findsOneWidget);
    expect(find.text('Kepala Sekolah'), findsOneWidget);
  });

  testWidgets('Validasi menolak kredensial kosong', (tester) async {
    await pumpPhone(tester, buildApp());
    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.enterText(find.byType(TextField).at(1), '');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pump();

    expect(find.text('Username dan password wajib diisi.'), findsOneWidget);
    expect(find.text('Masuk ke Sistem'), findsOneWidget);
  });

  testWidgets('Login gagal menampilkan error credentials', (tester) async {
    await pumpPhone(tester, buildApp());
    await tester.enterText(find.byType(TextField).at(0), 'salah@alanshar.sch.id');
    await tester.enterText(find.byType(TextField).at(1), 'salah');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Username atau password salah.'), findsOneWidget);
    expect(find.text('Masuk ke Sistem'), findsOneWidget);
  });

  testWidgets('Login guru membuka dashboard dan jadwal', (tester) async {
    await pumpPhone(tester, buildApp());
    await loginAs(
      tester,
      roleLabel: 'Guru',
      username: 'ratna@alanshar.sch.id',
      password: 'demo',
    );

    expect(find.text('Bu Ratna Sari'), findsOneWidget);
    expect(find.text('Jadwal mengajar'), findsOneWidget);

    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();
    expect(find.text('Jadwal mengajar minggu ini'), findsOneWidget);

    await tester.tap(find.text('Absensi'));
    await tester.pumpAndSettle();
    expect(find.text('Absensi kelas'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Simpan absensi'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Simpan absensi'), findsOneWidget);
  });

  testWidgets('Login orang tua membuka portal anak', (tester) async {
    await pumpPhone(tester, buildApp());
    await loginAs(
      tester,
      roleLabel: 'Orang Tua',
      username: 'ortu@alanshar.sch.id',
      password: 'demo',
    );

    expect(find.text('Ibu Siti Ramadhani'), findsOneWidget);
    expect(find.text('Aulia Zahra Ramadhani'), findsWidgets);

    await tester.tap(find.text('Kehadiran'));
    await tester.pumpAndSettle();
    expect(find.text('Kehadiran anak'), findsOneWidget);
  });

  testWidgets('Login kepala sekolah membuka dashboard monitoring', (
    tester,
  ) async {
    await pumpPhone(tester, buildApp());
    await loginAs(
      tester,
      roleLabel: 'Kepala Sekolah',
      username: 'kepsek@alanshar.sch.id',
      password: 'demo',
    );

    expect(find.text('Pak Hidayat Rahman'), findsOneWidget);
    expect(find.text('Jadwal menunggu persetujuan'), findsOneWidget);

    await tester.tap(find.text('Persetujuan'));
    await tester.pumpAndSettle();
    expect(find.text('Persetujuan jadwal CSP'), findsOneWidget);
  });

  testWidgets('Logout guru kembali ke halaman login', (tester) async {
    await pumpPhone(tester, buildApp());
    await loginAs(
      tester,
      roleLabel: 'Guru',
      username: 'ratna@alanshar.sch.id',
      password: 'demo',
    );

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Keluar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Sistem'), findsOneWidget);
    expect(find.text('Bu Ratna Sari'), findsNothing);
  });

  testWidgets('Role navigasi mengikuti akun, bukan hanya pilihan chip', (
    tester,
  ) async {
    await pumpPhone(tester, buildApp());

    // Chip Orang Tua dipilih, tetapi kredensial guru yang dipakai.
    await tester.tap(find.text('Orang Tua'));
    await tester.pump();
    await tester.enterText(
      find.byType(TextField).at(0),
      'ratna@alanshar.sch.id',
    );
    await tester.enterText(find.byType(TextField).at(1), 'demo');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Bu Ratna Sari'), findsOneWidget);
    expect(find.text('Absensi'), findsOneWidget);
    expect(find.text('Kehadiran'), findsNothing);
  });
}
