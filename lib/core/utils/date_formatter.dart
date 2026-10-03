import 'package:intl/intl.dart';
import 'package:mingda_app/core/localization/app_language.dart';

extension DateFormatter on DateTime {
  String toIndonesianString() {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
  }

  String toLocalizedString(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return DateFormat('EEEE, MMMM d, yyyy', 'en_US').format(this);
      case AppLanguage.zh:
        const weekDaysZh = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
        final dayName = weekDaysZh[weekday - 1];
        return '$year年$month月$day日 $dayName';
      case AppLanguage.id:
        return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
    }
  }
  String toLocalizedShortDate(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return DateFormat('dd MMM yyyy', 'en_US').format(this);
      case AppLanguage.zh:
        return '$year年${month.toString().padLeft(2, '0')}月${day.toString().padLeft(2, '0')}日';
      case AppLanguage.id:
        return DateFormat('dd MMM yyyy', 'id_ID').format(this);
    }
  }
}

extension StringDateFormatter on String {
  String toIndonesianDateString() {
    return toLocalizedDateString(AppLanguage.id);
  }

  String toLocalizedDateString(AppLanguage language) {
    final dt = DateTime.tryParse(this)?.toLocal();
    if (dt == null) return this;
    switch (language) {
      case AppLanguage.en:
        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      case AppLanguage.zh:
        return '${dt.year}年${dt.month}月${dt.day}日';
      case AppLanguage.id:
        const months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    }
  }
}

