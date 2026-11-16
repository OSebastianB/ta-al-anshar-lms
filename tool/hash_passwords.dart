import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

void main() {
  const salt = 'alanshar-lms-v1';
  const accounts = [
    ('ratna@alanshar.sch.id', 'demo'),
    ('guru@alanshar.sch.id', 'guru123'),
    ('ortu@alanshar.sch.id', 'demo'),
    ('kepsek@alanshar.sch.id', 'demo'),
  ];
  for (final (user, pass) in accounts) {
    final digest = sha256.convert(utf8.encode('$salt|$user|$pass'));
    stdout.writeln('$user => $digest');
  }
}
