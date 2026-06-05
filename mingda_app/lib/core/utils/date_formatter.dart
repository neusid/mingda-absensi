import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String toIndonesianString() {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
  }
}
