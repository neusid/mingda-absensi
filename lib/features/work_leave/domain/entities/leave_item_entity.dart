import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/localization/app_language.dart';

class LeaveItemEntity extends Equatable {
  final int id;
  final int? employeeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String? attachment;
  final String? createdAt;
  final String? updatedAt;

  const LeaveItemEntity({
    required this.id,
    this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  /// Label yang ramah ditampilkan pada UI (misal: 'Izin Sakit', 'Cuti Tahunan', 'Izin')
  String get displayTitle => localizedTitle(AppLanguage.id);

  String localizedTitle(AppLanguage lang) {
    final lower = leaveType.toLowerCase();
    if (lower.contains('sakit')) {
      return switch (lang) {
        AppLanguage.en => 'Sick Leave',
        AppLanguage.zh => '病假申请',
        AppLanguage.id => 'Izin Sakit',
      };
    } else if (lower.contains('cuti')) {
      return switch (lang) {
        AppLanguage.en => 'Annual Leave',
        AppLanguage.zh => '年假申请',
        AppLanguage.id => 'Cuti Tahunan',
      };
    } else if (lower.contains('izin')) {
      return switch (lang) {
        AppLanguage.en => 'Permission Leave',
        AppLanguage.zh => '事假申请',
        AppLanguage.id => 'Izin Kerja',
      };
    }
    return localizedReason(lang).isNotEmpty
        ? localizedReason(lang)
        : (switch (lang) {
            AppLanguage.en => 'Leave Application',
            AppLanguage.zh => '请假申请',
            AppLanguage.id => 'Pengajuan Cuti / Izin',
          });
  }

  /// Status terstandardisasi dalam berbagai bahasa
  String get displayStatus => localizedStatus(AppLanguage.id);

  String localizedStatus(AppLanguage lang) {
    final lower = status.toLowerCase();
    if (lower == 'approved' || lower == 'disetujui' || lower == '已批准') {
      return switch (lang) {
        AppLanguage.en => 'Approved',
        AppLanguage.zh => '已批准',
        AppLanguage.id => 'Disetujui',
      };
    } else if (lower == 'rejected' || lower == 'ditolak' || lower == '已驳回') {
      return switch (lang) {
        AppLanguage.en => 'Rejected',
        AppLanguage.zh => '已驳回',
        AppLanguage.id => 'Ditolak',
      };
    } else {
      return switch (lang) {
        AppLanguage.en => 'Pending',
        AppLanguage.zh => '待审批',
        AppLanguage.id => 'Menunggu',
      };
    }
  }

  String localizedReason(AppLanguage lang) {
    if (reason == 'Izin Sakit Flu & Demam') {
      return switch (lang) {
        AppLanguage.en => 'Flu & Fever Sick Leave',
        AppLanguage.zh => '流感发烧病假',
        AppLanguage.id => 'Izin Sakit Flu & Demam',
      };
    }
    if (reason == 'Cuti Tahunan Pulang Kampung') {
      return switch (lang) {
        AppLanguage.en => 'Annual Leave for Hometown Visit',
        AppLanguage.zh => '返乡探亲年假',
        AppLanguage.id => 'Cuti Tahunan Pulang Kampung',
      };
    }
    if (reason == 'Izin Keperluan Mendesak') {
      return switch (lang) {
        AppLanguage.en => 'Urgent Personal Matter',
        AppLanguage.zh => '紧急事由请假',
        AppLanguage.id => 'Izin Keperluan Mendesak',
      };
    }
    if (reason == 'Cuti Bersama') {
      return switch (lang) {
        AppLanguage.en => 'Company Joint Holiday',
        AppLanguage.zh => '公司统筹公休',
        AppLanguage.id => 'Cuti Bersama',
      };
    }
    return reason;
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        leaveType,
        startDate,
        endDate,
        reason,
        status,
        attachment,
        createdAt,
        updatedAt,
      ];
}
