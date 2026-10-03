class HiveConstants {
  static const String cacheBoxName = 'mingda_cache_box';
  static const String offlineQueueBoxName = 'mingda_offline_queue_box';

  // Cache keys
  static const String profileKey = 'cache_profile';
  static const String attendanceSummaryKey = 'cache_attendance_summary';
  static const String attendanceHistoryKey = 'cache_attendance_history';
  static const String workLeaveListKey = 'cache_work_leave_list';
  static const String notificationsKey = 'cache_notifications';
  static const String warningLettersKey = 'cache_warning_letters';

  // Action types for offline queue
  static const String actionSubmitLeave = 'SUBMIT_LEAVE';
  static const String actionCheckIn = 'CHECK_IN';
  static const String actionCheckOut = 'CHECK_OUT';
}
