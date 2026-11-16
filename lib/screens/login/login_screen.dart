import 'package:material_ui/material_ui.dart';

import '../../core/errors/auth_exception.dart';
import '../../repositories/mock_auth_repository.dart';
import '../../state/session_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  AppRole _roleHint = AppRole.guru;
  bool _obscure = true;
  bool _remember = true;
  String? _error;
  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;
    _prefilled = true;
    _loadRemembered();
  }

  Future<void> _loadRemembered() async {
    final remembered = await SessionScope.of(context).rememberedUsername();
    if (!mounted) return;
    if (remembered != null && remembered.isNotEmpty) {
      _email.text = remembered;
      return;
    }
    _applyRoleHint(AppRole.guru);
  }

  void _applyRoleHint(AppRole role) {
    final demo = MockAuthRepository.demoCredentialsFor(role);
    setState(() {
      _roleHint = role;
      _email.text = demo.username;
      _password.text = demo.password;
      _error = null;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final username = _email.text.trim();
    final password = _password.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _error = 'Username dan password wajib diisi.');
      return;
    }
    if (password.length < 4) {
      setState(() => _error = 'Password minimal 4 karakter.');
      return;
    }

    final session = SessionScope.of(context);
    setState(() => _error = null);

    try {
      await session.login(
        username: username,
        password: password,
        rememberMe: _remember,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal masuk. Silakan coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final loading = session.isAuthenticating;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFDCE9F8), AppColors.bg],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      _BrandHeader(),
                      const SizedBox(height: 14),
                      _LoginCard(
                        email: _email,
                        password: _password,
                        roleHint: _roleHint,
                        obscure: _obscure,
                        remember: _remember,
                        error: _error,
                        loading: loading,
                        onRoleHint: loading ? null : _applyRoleHint,
                        onToggleObscure: () =>
                            setState(() => _obscure = !_obscure),
                        onRemember: (value) =>
                            setState(() => _remember = value),
                        onSubmit: loading ? null : _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.16),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo-al-anshar.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'LMS SD ISLAM',
          style: AppText.style(
            size: 12,
            weight: FontWeight.w700,
            color: AppColors.navyMid,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Al-Anshar',
          style: AppText.style(
            size: 24,
            weight: FontWeight.w800,
            color: AppColors.navy,
            height: 1.1,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'KOTA BEKASI',
          style: AppText.style(
            size: 11,
            weight: FontWeight.w600,
            color: AppColors.muted,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.email,
    required this.password,
    required this.roleHint,
    required this.obscure,
    required this.remember,
    required this.error,
    required this.loading,
    required this.onRoleHint,
    required this.onToggleObscure,
    required this.onRemember,
    required this.onSubmit,
  });

  final TextEditingController email;
  final TextEditingController password;
  final AppRole roleHint;
  final bool obscure;
  final bool remember;
  final String? error;
  final bool loading;
  final ValueChanged<AppRole>? onRoleHint;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool> onRemember;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.07),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masuk ke Sistem',
            style: AppText.style(
              size: 20,
              weight: FontWeight.w800,
              color: AppColors.navy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Masuk dengan akun Guru, Orang Tua, atau Kepala Sekolah. '
            'Role ditentukan dari akun yang berhasil diautentikasi.',
            style: AppText.style(size: 13.5, color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Akun demo',
            style: AppText.style(
              size: 13,
              weight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _RoleOption(
                  label: 'Guru',
                  icon: Icons.school_outlined,
                  selected: roleHint == AppRole.guru,
                  onTap: onRoleHint == null
                      ? null
                      : () => onRoleHint!(AppRole.guru),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RoleOption(
                  label: 'Orang Tua',
                  icon: Icons.family_restroom_outlined,
                  selected: roleHint == AppRole.orangTua,
                  onTap: onRoleHint == null
                      ? null
                      : () => onRoleHint!(AppRole.orangTua),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _RoleOption(
            label: 'Kepala Sekolah',
            icon: Icons.apartment_outlined,
            selected: roleHint == AppRole.kepalaSekolah,
            onTap: onRoleHint == null
                ? null
                : () => onRoleHint!(AppRole.kepalaSekolah),
          ),
          const SizedBox(height: 6),
          Text(
            'Admin tetap menggunakan website desktop.',
            style: AppText.style(size: 11.5, color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Username / Email',
            controller: email,
            hint: 'nama@alanshar.sch.id',
            icon: Icons.mail_outline_rounded,
            textInputAction: TextInputAction.next,
            enabled: !loading,
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Password',
            controller: password,
            hint: 'Masukkan password',
            icon: Icons.lock_outline_rounded,
            obscure: obscure,
            textInputAction: TextInputAction.done,
            enabled: !loading,
            onSubmitted: onSubmit,
            trailing: IconButton(
              tooltip: obscure ? 'Tampilkan password' : 'Sembunyikan password',
              onPressed: loading ? null : onToggleObscure,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: remember,
                  onChanged: loading
                      ? null
                      : (value) => onRemember(value ?? false),
                  activeColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.borderStrong),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Ingat saya',
                style: AppText.style(size: 13, color: AppColors.text),
              ),
            ],
          ),
          if (error != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF3C1C1)),
              ),
              child: Text(
                error!,
                style: AppText.style(
                  size: 12.5,
                  color: const Color(0xFF9B2C2C),
                  height: 1.35,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onSubmit,
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.login_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Login',
                          style: AppText.style(
                            size: 15,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Mock auth · password tidak disimpan',
              style: AppText.style(size: 11.5, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.white : AppColors.navy;
    return Material(
      color: selected ? AppColors.accent : AppColors.bg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppText.style(
                  size: 13.5,
                  weight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.trailing,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? trailing;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.style(
            size: 13,
            weight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscure,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
          style: AppText.style(size: 14, weight: FontWeight.w500),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.style(size: 14, color: const Color(0xFF9AA8B8)),
            filled: true,
            fillColor: AppColors.bg,
            prefixIcon: Icon(icon, size: 18, color: AppColors.muted),
            suffixIcon: trailing,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFB7CCEB),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
