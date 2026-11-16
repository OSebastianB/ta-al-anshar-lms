import 'app_role.dart';

/// Profil pengguna yang diautentikasi.
/// Field disiapkan agar mudah dipetakan ke JSON backend nanti.
class UserAccount {
  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.initials,
    required this.roleLabel,
    this.phone,
  });

  final String id;
  final String name;
  final String email;
  final AppRole role;
  final String initials;
  final String roleLabel;
  final String? phone;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'initials': initials,
      'roleLabel': roleLabel,
      'phone': phone,
    };
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: AppRole.values.byName(json['role'] as String),
      initials: json['initials'] as String,
      roleLabel: json['roleLabel'] as String,
      phone: json['phone'] as String?,
    );
  }
}
