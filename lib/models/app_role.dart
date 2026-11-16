enum AppRole {
  guru,
  orangTua,
  kepalaSekolah,
}

extension AppRoleX on AppRole {
  String get label {
    return switch (this) {
      AppRole.guru => 'Guru',
      AppRole.orangTua => 'Orang Tua',
      AppRole.kepalaSekolah => 'Kepala Sekolah',
    };
  }
}
