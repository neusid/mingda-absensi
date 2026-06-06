import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toIndonesianString() {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
  }
}

extension StringDateFormatter on String {
  String toIndonesianDateString() {
    final date = DateTime.parse(this).toLocal();
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
