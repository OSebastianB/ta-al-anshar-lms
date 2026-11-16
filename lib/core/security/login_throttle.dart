/// Pembatas percobaan login lokal untuk mengurangi brute-force di perangkat.
/// Proteksi penuh tetap membutuhkan rate-limit di server.
class LoginThrottle {
  LoginThrottle({
    this.maxAttempts = 5,
    this.lockoutDuration = const Duration(minutes: 1),
  });

  final int maxAttempts;
  final Duration lockoutDuration;

  final Map<String, _AttemptState> _states = {};

  String _key(String username) => username.trim().toLowerCase();

  /// Sisa waktu lockout; null jika tidak terkunci.
  Duration? remainingLockout(String username) {
    final state = _states[_key(username)];
    if (state == null || state.lockedUntil == null) return null;
    final remaining = state.lockedUntil!.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      state.lockedUntil = null;
      state.failures = 0;
      return null;
    }
    return remaining;
  }

  bool isLocked(String username) => remainingLockout(username) != null;

  void recordFailure(String username) {
    final key = _key(username);
    final state = _states.putIfAbsent(key, _AttemptState.new);
    final remaining = remainingLockout(username);
    if (remaining != null) return;

    state.failures += 1;
    if (state.failures >= maxAttempts) {
      state.lockedUntil = DateTime.now().add(lockoutDuration);
      state.failures = 0;
    }
  }

  void recordSuccess(String username) {
    _states.remove(_key(username));
  }

  void reset() => _states.clear();
}

class _AttemptState {
  int failures = 0;
  DateTime? lockedUntil;
}
