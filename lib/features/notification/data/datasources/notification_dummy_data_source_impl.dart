import 'package:mingda_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:mingda_app/features/notification/data/models/notification_model.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';

class NotificationDummyDataSourceImpl implements NotificationRemoteDataSource {
  static List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 'notif-1',
      title: 'Surat Edaran Libur Nasional & Cuti Bersama',
      message:
          'Diberitahukan kepada seluruh karyawan PT Mingda bahwa kegiatan operasional diliburkan dalam rangka Hari Libur Nasional & Cuti Bersama. Pastikan seluruh pekerjaan operasional dan serah terima tugas telah diselesaikan dengan tertib.',
      category: NotificationCategory.announcement,
      type: NotificationType.announcement,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      metadata: const {
        'sender': 'HRD PT Mingda',
        'priority': 'Penting',
        'document_no': 'SE/HRD/X/2026/089',
      },
    ),
    NotificationModel(
      id: 'notif-2',
      title: 'Pengajuan Cuti Tahunan Disetujui',
      message:
          'Selamat, permohonan Cuti Tahunan Anda untuk periode 12 Oktober 2026 s/d 14 Oktober 2026 (3 hari kerja) telah disetujui oleh Manajer Divisi dan HRD.',
      category: NotificationCategory.activity,
      type: NotificationType.leaveApproval,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      actionUrl: '/work-leave',
      metadata: const {
        'leave_id': 'LV-2026-10-004',
        'status': 'Approved',
        'approver': 'Ahmad Fauzi (Head of Dept)',
      },
    ),
    NotificationModel(
      id: 'notif-3',
      title: 'Sosialisasi Pembaruan Presensi Biometrik Wajah',
      message:
          'Mulai tanggal 1 November 2026, sistem absensi mobile Mingda akan menerapkan verifikasi liveness detection biometrik wajah generasi terbaru untuk meningkatkan akurasi data kehadiran.',
      category: NotificationCategory.announcement,
      type: NotificationType.announcement,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: true,
      metadata: const {
        'sender': 'IT Department & HRD',
        'priority': 'Umum',
      },
    ),
    NotificationModel(
      id: 'notif-4',
      title: 'Slip Gaji Bulan September 2026 Telah Terbit',
      message:
          'Slip gaji resmi Anda untuk periode September 2026 telah selesai diproses oleh bagian Finance dan siap untuk ditinjau atau diunduh melalui aplikasi.',
      category: NotificationCategory.activity,
      type: NotificationType.payslipReleased,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      isRead: true,
      actionUrl: '/payslip',
      metadata: const {
        'period': 'September 2026',
        'status': 'Finalized',
      },
    ),
    NotificationModel(
      id: 'notif-5',
      title: 'Pengingat Check-Out Jam Kerja Shift Pagi',
      message:
          'Waktu kerja shift pagi Anda berakhir pada pukul 17:00 WIB. Pastikan melakukan check-out presensi harian tepat waktu di lokasi kerja yang terverifikasi.',
      category: NotificationCategory.activity,
      type: NotificationType.attendanceReminder,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      isRead: true,
      actionUrl: '/root',
      metadata: const {
        'shift': 'Shift Pagi (08:00 - 17:00)',
      },
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return List<NotificationModel>.from(_mockNotifications);
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _mockNotifications.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = _mockNotifications[index];
      _mockNotifications[index] = NotificationModel(
        id: current.id,
        title: current.title,
        message: current.message,
        category: current.category,
        type: current.type,
        createdAt: current.createdAt,
        isRead: true,
        actionUrl: current.actionUrl,
        metadata: current.metadata,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockNotifications = _mockNotifications.map((current) {
      return NotificationModel(
        id: current.id,
        title: current.title,
        message: current.message,
        category: current.category,
        type: current.type,
        createdAt: current.createdAt,
        isRead: true,
        actionUrl: current.actionUrl,
        metadata: current.metadata,
      );
    }).toList();
  }
}
