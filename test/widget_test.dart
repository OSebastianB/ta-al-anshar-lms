import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:al_anshar_lms/app.dart';

void main() {
  Future<void> pumpPhone(WidgetTester tester, Widget app) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app);
  }

  testWidgets('Halaman login menampilkan identitas sekolah', (tester) async {
    await pumpPhone(tester, const LmsApp());

    expect(find.text('Masuk ke Sistem'), findsOneWidget);
    expect(find.text('Al-Anshar'), findsOneWidget);
    expect(find.text('Guru'), findsOneWidget);
    expect(find.text('Orang Tua'), findsOneWidget);
  });

  testWidgets('Login guru membuka dashboard dan jadwal', (tester) async {
    await pumpPhone(tester, const LmsApp());
    await tester.enterText(find.byType(TextField).at(0), 'ratna@alanshar.sch.id');
    await tester.enterText(find.byType(TextField).at(1), 'demo');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

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
    await pumpPhone(tester, const LmsApp());
    await tester.tap(find.text('Orang Tua'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).at(0), 'ortu@alanshar.sch.id');
    await tester.enterText(find.byType(TextField).at(1), 'demo');
    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Ibu Siti Ramadhani'), findsOneWidget);
    expect(find.text('Aulia Zahra Ramadhani'), findsWidgets);

    await tester.tap(find.text('Kehadiran'));
    await tester.pumpAndSettle();
    expect(find.text('Kehadiran anak'), findsOneWidget);
  });
}
