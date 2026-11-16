class DataException implements Exception {
  const DataException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'DataException($code): $message';
}
