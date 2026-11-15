import 'package:flutter/widgets.dart';

enum AppRole { guru, orangTua, kepalaSekolah }

class SessionController extends ChangeNotifier {
  AppRole? role;
  int tabIndex = 0;

  void login(AppRole value) {
    role = value;
    tabIndex = 0;
    notifyListeners();
  }

  void logout() {
    role = null;
    tabIndex = 0;
    notifyListeners();
  }

  void setTab(int index) {
    if (tabIndex == index) return;
    tabIndex = index;
    notifyListeners();
  }
}

class SessionScope extends InheritedNotifier<SessionController> {
  const SessionScope({
    super.key,
    required SessionController controller,
    required super.child,
  }) : super(notifier: controller);

  static SessionController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'SessionScope tidak ditemukan');
    return scope!.notifier!;
  }
}
