import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';
import 'package:mingda_app/features/dashboard/data/models/profile_model.dart';

abstract class DashboardRemoteDataSource {
  Future<void> SignOutDataSource(String token);
  Future<ProfileModel> getProfile();
  Future<AttendanceSummaryModel> getAttendanceSummary();
  Future<AttendanceHistoryModel> getAttendanceHistory();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
