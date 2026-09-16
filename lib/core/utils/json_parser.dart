/// Helper untuk parsing nilai dari JSON yang bisa berupa `num`, `String`,
/// `bool`, atau `null`. Server terkadang mengirim angka sebagai String
/// (misal `"85"`), jadi helper ini menoleransi itu agar tidak crash.
int parseIntValue(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback;
    return int.tryParse(trimmed) ?? fallback;
  }
  if (value is bool) return value ? 1 : 0;
  return fallback;
}

double parseDoubleValue(dynamic value, [double? fallback]) {
  if (value == null) return fallback ?? 0.0;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fallback ?? 0.0;
    return double.tryParse(trimmed) ?? fallback ?? 0.0;
  }
  return fallback ?? 0.0;
}

bool parseBoolValue(dynamic value, [bool fallback = false]) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final t = value.trim().toLowerCase();
    if (t == 'true' || t == '1') return true;
    if (t == 'false' || t == '0') return false;
    return fallback;
  }
  return fallback;
}
