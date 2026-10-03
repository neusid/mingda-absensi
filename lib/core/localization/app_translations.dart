import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/localization/bloc/language_state.dart';

/// Extension on [BuildContext] to conveniently access current language and translations.
/// Calling `context.tr` or `context.currentLanguage` automatically binds the widget to [LanguageBloc].
extension LocalizationExtension on BuildContext {
  LanguageState get languageState {
    try {
      final bloc = BlocProvider.of<LanguageBloc>(this, listen: true);
      return bloc.state;
    } catch (_) {
      return const LanguageState(language: AppLanguage.id);
    }
  }

  AppTranslations get tr => languageState.tr;
  AppLanguage get currentLanguage => languageState.language;
}

class AppTranslations {
  final AppLanguage language;

  const AppTranslations(this.language);

  // ==========================================
  // GENERAL & ACTIONS
  // ==========================================
  String get appName => switch (language) {
        AppLanguage.en => 'Mingda Attendance',
        AppLanguage.zh => '铭达移动考勤',
        AppLanguage.id => 'Mingda Absensi',
      };

  String get save => switch (language) {
        AppLanguage.en => 'Save',
        AppLanguage.zh => '保存',
        AppLanguage.id => 'Simpan',
      };

  String get cancel => switch (language) {
        AppLanguage.en => 'Cancel',
        AppLanguage.zh => '取消',
        AppLanguage.id => 'Batal',
      };

  String get confirm => switch (language) {
        AppLanguage.en => 'Confirm',
        AppLanguage.zh => '确认',
        AppLanguage.id => 'Konfirmasi',
      };

  String get back => switch (language) {
        AppLanguage.en => 'Back',
        AppLanguage.zh => '返回',
        AppLanguage.id => 'Kembali',
      };

  String get close => switch (language) {
        AppLanguage.en => 'Close',
        AppLanguage.zh => '关闭',
        AppLanguage.id => 'Tutup',
      };

  String get search => switch (language) {
        AppLanguage.en => 'Search',
        AppLanguage.zh => '搜索',
        AppLanguage.id => 'Cari',
      };

  String get reset => switch (language) {
        AppLanguage.en => 'Reset',
        AppLanguage.zh => '重置',
        AppLanguage.id => 'Reset',
      };

  String get all => switch (language) {
        AppLanguage.en => 'All',
        AppLanguage.zh => '全部',
        AppLanguage.id => 'Semua',
      };

  String get status => switch (language) {
        AppLanguage.en => 'Status',
        AppLanguage.zh => '状态',
        AppLanguage.id => 'Status',
      };

  String get statActive => switch (language) {
        AppLanguage.en => 'Active',
        AppLanguage.zh => '生效中',
        AppLanguage.id => 'Aktif',
      };

  String get statCompleted => switch (language) {
        AppLanguage.en => 'Completed',
        AppLanguage.zh => '已结案',
        AppLanguage.id => 'Selesai',
      };

  String get loading => switch (language) {
        AppLanguage.en => 'Loading...',
        AppLanguage.zh => '加载中...',
        AppLanguage.id => 'Memuat...',
      };

  String get retry => switch (language) {
        AppLanguage.en => 'Retry',
        AppLanguage.zh => '重试',
        AppLanguage.id => 'Coba Lagi',
      };

  String get delete => switch (language) {
        AppLanguage.en => 'Delete',
        AppLanguage.zh => '删除',
        AppLanguage.id => 'Hapus',
      };

  String get selectDateTitle => switch (language) {
        AppLanguage.en => 'SELECT DATE',
        AppLanguage.zh => '选择日期',
        AppLanguage.id => 'PILIH TANGGAL',
      };

  String get download => switch (language) {
        AppLanguage.en => 'Download',
        AppLanguage.zh => '下载',
        AppLanguage.id => 'Unduh',
      };

  String get upload => switch (language) {
        AppLanguage.en => 'Upload',
        AppLanguage.zh => '上传',
        AppLanguage.id => 'Unggah',
      };

  String get details => switch (language) {
        AppLanguage.en => 'Details',
        AppLanguage.zh => '详情',
        AppLanguage.id => 'Detail',
      };

  String get languageTitle => switch (language) {
        AppLanguage.en => 'Language',
        AppLanguage.zh => '语言设置',
        AppLanguage.id => 'Bahasa',
      };

  String get selectLanguage => switch (language) {
        AppLanguage.en => 'Select Language',
        AppLanguage.zh => '选择语言',
        AppLanguage.id => 'Pilih Bahasa',
      };

  // ==========================================
  // ROOT BOTTOM NAVIGATION
  // ==========================================
  String get navHome => switch (language) {
        AppLanguage.en => 'Home',
        AppLanguage.zh => '首页',
        AppLanguage.id => 'Beranda',
      };

  String get navLeave => switch (language) {
        AppLanguage.en => 'Leave',
        AppLanguage.zh => '请假',
        AppLanguage.id => 'Cuti',
      };

  String get navWarning => switch (language) {
        AppLanguage.en => 'Warning',
        AppLanguage.zh => '警告',
        AppLanguage.id => 'Peringatan',
      };

  String get navWallet => switch (language) {
        AppLanguage.en => 'Wallet',
        AppLanguage.zh => '钱包',
        AppLanguage.id => 'Dompet',
      };

  String get navProfile => switch (language) {
        AppLanguage.en => 'Profile',
        AppLanguage.zh => '个人',
        AppLanguage.id => 'Profil',
      };

  // ==========================================
  // DASHBOARD & GREETINGS
  // ==========================================
  String greetingByHour(int hour) {
    switch (language) {
      case AppLanguage.en:
        if (hour < 12) return 'Good Morning,';
        if (hour < 18) return 'Good Afternoon,';
        return 'Good Evening,';
      case AppLanguage.zh:
        if (hour < 12) return '早上好，';
        if (hour < 18) return '下午好，';
        return '晚上好，';
      case AppLanguage.id:
        if (hour < 11) return 'Selamat Pagi,';
        if (hour < 15) return 'Selamat Siang,';
        if (hour < 18) return 'Selamat Sore,';
        return 'Selamat Malam,';
    }
  }

  String get morningShift => switch (language) {
        AppLanguage.en => 'Morning Shift (08:00 - 17:00)',
        AppLanguage.zh => '早班 (08:00 - 17:00)',
        AppLanguage.id => 'Shift Pagi (08:00 - 17:00)',
      };

  String get workSchedule => switch (language) {
        AppLanguage.en => 'Work Schedule',
        AppLanguage.zh => '工作班次',
        AppLanguage.id => 'Jadwal Kerja',
      };

  String get checkIn => switch (language) {
        AppLanguage.en => 'Check In',
        AppLanguage.zh => '签到打卡',
        AppLanguage.id => 'Absensi Masuk',
      };

  String get checkOut => switch (language) {
        AppLanguage.en => 'Check Out',
        AppLanguage.zh => '签退打卡',
        AppLanguage.id => 'Absensi Pulang',
      };

  String get checkedInStatus => switch (language) {
        AppLanguage.en => 'Checked In',
        AppLanguage.zh => '已签到',
        AppLanguage.id => 'Sudah Check In',
      };

  String get notCheckedInStatus => switch (language) {
        AppLanguage.en => 'Not Checked In',
        AppLanguage.zh => '未打卡',
        AppLanguage.id => 'Belum Check In',
      };

  String get onTime => switch (language) {
        AppLanguage.en => 'On Time',
        AppLanguage.zh => '准时',
        AppLanguage.id => 'Tepat Waktu',
      };

  String get checkInLimit => switch (language) {
        AppLanguage.en => 'Check-in Limit',
        AppLanguage.zh => '最晚签到',
        AppLanguage.id => 'Batas Masuk',
      };

  String get checkOutTime => switch (language) {
        AppLanguage.en => 'Check-out Time',
        AppLanguage.zh => '下班时间',
        AppLanguage.id => 'Jam Pulang',
      };

  String get tapToAttendance => switch (language) {
        AppLanguage.en => 'Tap to Check In',
        AppLanguage.zh => '点击进行考勤打卡',
        AppLanguage.id => 'Klik untuk Presensi',
      };

  String get quickServices => switch (language) {
        AppLanguage.en => 'Quick Services',
        AppLanguage.zh => '快捷服务',
        AppLanguage.id => 'Layanan Cepat',
      };

  String get menuWorkLeave => switch (language) {
        AppLanguage.en => 'Work Leave',
        AppLanguage.zh => '请假申请',
        AppLanguage.id => 'Cuti & Izin',
      };

  String get menuPayslip => switch (language) {
        AppLanguage.en => 'Payslip',
        AppLanguage.zh => '工资单',
        AppLanguage.id => 'Slip Gaji',
      };

  String get menuHistory => switch (language) {
        AppLanguage.en => 'History',
        AppLanguage.zh => '考勤记录',
        AppLanguage.id => 'Riwayat',
      };

  String get menuWarningLetter => switch (language) {
        AppLanguage.en => 'Warning Letter',
        AppLanguage.zh => '警告信',
        AppLanguage.id => 'Surat Peringatan',
      };

  String get attendanceSummary => switch (language) {
        AppLanguage.en => 'Attendance Summary',
        AppLanguage.zh => '考勤概览',
        AppLanguage.id => 'Ringkasan Kehadiran',
      };

  String get statPresent => switch (language) {
        AppLanguage.en => 'Present',
        AppLanguage.zh => '出勤',
        AppLanguage.id => 'Hadir',
      };

  String get statLate => switch (language) {
        AppLanguage.en => 'Late',
        AppLanguage.zh => '迟到',
        AppLanguage.id => 'Terlambat',
      };

  String get statLeave => switch (language) {
        AppLanguage.en => 'Leave / Sick',
        AppLanguage.zh => '请假 / 休假',
        AppLanguage.id => 'Izin / Sakit',
      };

  String get statAlpha => switch (language) {
        AppLanguage.en => 'Absent',
        AppLanguage.zh => '旷工',
        AppLanguage.id => 'Alpha',
      };

  String get statPermission => switch (language) {
        AppLanguage.en => 'Permission',
        AppLanguage.zh => '事假',
        AppLanguage.id => 'Izin',
      };

  String get statAnnualLeave => switch (language) {
        AppLanguage.en => 'Leave',
        AppLanguage.zh => '请假',
        AppLanguage.id => 'Cuti',
      };

  String get statSick => switch (language) {
        AppLanguage.en => 'Sick',
        AppLanguage.zh => '病假',
        AppLanguage.id => 'Sakit',
      };

  String get thisMonth => switch (language) {
        AppLanguage.en => 'this month',
        AppLanguage.zh => '本月',
        AppLanguage.id => 'bulan ini',
      };

  String get leaveBalance => switch (language) {
        AppLanguage.en => 'Leave Balance',
        AppLanguage.zh => '剩余年假',
        AppLanguage.id => 'Sisa Cuti',
      };

  String get yourActivity => switch (language) {
        AppLanguage.en => 'Your activity',
        AppLanguage.zh => '最近动态',
        AppLanguage.id => 'Aktivitas Anda',
      };

  String get noAttendanceHistory => switch (language) {
        AppLanguage.en => 'No attendance history yet',
        AppLanguage.zh => '暂无考勤记录',
        AppLanguage.id => 'Belum ada riwayat absensi',
      };

  String get announcements => switch (language) {
        AppLanguage.en => 'Company Announcements',
        AppLanguage.zh => '公司公告',
        AppLanguage.id => 'Pengumuman Perusahaan',
      };

  String get viewAll => switch (language) {
        AppLanguage.en => 'View All',
        AppLanguage.zh => '查看全部',
        AppLanguage.id => 'Lihat Semua',
      };

  // ==========================================
  // AUTH (LOGIN & FORGOT PASSWORD)
  // ==========================================
  String get loginWelcomeBack => switch (language) {
        AppLanguage.en => 'Welcome Back, 👋',
        AppLanguage.zh => '欢迎回来，👋',
        AppLanguage.id => 'Selamat Datang, 👋',
      };

  String get loginSubtitle => switch (language) {
        AppLanguage.en => 'Please enter your login details to access your account.',
        AppLanguage.zh => '请输入您的登录凭据以访问您的账户。',
        AppLanguage.id => 'Silakan masukkan detail akun untuk mengakses sistem.',
      };

  String get emailLabel => switch (language) {
        AppLanguage.en => 'E-Mail',
        AppLanguage.zh => '电子邮箱',
        AppLanguage.id => 'E-Mail / NIK',
      };

  String get emailHint => switch (language) {
        AppLanguage.en => 'Enter your email or NIK',
        AppLanguage.zh => '输入您的邮箱或工号',
        AppLanguage.id => 'Masukkan email atau NIK Anda',
      };

  String get passwordLabel => switch (language) {
        AppLanguage.en => 'Password',
        AppLanguage.zh => '密码',
        AppLanguage.id => 'Kata Sandi',
      };

  String get passwordHint => switch (language) {
        AppLanguage.en => 'Enter your password',
        AppLanguage.zh => '输入您的密码',
        AppLanguage.id => 'Masukkan kata sandi Anda',
      };

  String get rememberMe => switch (language) {
        AppLanguage.en => 'Remember me',
        AppLanguage.zh => '记住登录状态',
        AppLanguage.id => 'Ingat saya',
      };

  String get forgotPassword => switch (language) {
        AppLanguage.en => 'Forgot Password',
        AppLanguage.zh => '忘记密码',
        AppLanguage.id => 'Lupa Kata Sandi',
      };

  String get forgotPasswordQuestion => switch (language) {
        AppLanguage.en => 'Forgot Password?',
        AppLanguage.zh => '忘记密码？',
        AppLanguage.id => 'Lupa Kata Sandi?',
      };

  String get loginButton => switch (language) {
        AppLanguage.en => 'Sign In',
        AppLanguage.zh => '登录系统',
        AppLanguage.id => 'Masuk',
      };

  String get loggingIn => switch (language) {
        AppLanguage.en => 'Logging in...',
        AppLanguage.zh => '登录中...',
        AppLanguage.id => 'Memproses Masuk...',
      };

  String get forgotPasswordInstruction => switch (language) {
        AppLanguage.en =>
          "Enter your registered email address. We'll send instructions to reset your password.",
        AppLanguage.zh => '请输入您注册的公司电子邮箱。我们将向您发送重置密码的操作指引。',
        AppLanguage.id =>
          'Masukkan alamat email terdaftar Anda. Kami akan mengirimkan instruksi pemulihan kata sandi.',
      };

  String get forgotPasswordEmailLabel => switch (language) {
        AppLanguage.en => 'Company Email',
        AppLanguage.zh => '企业电子邮箱',
        AppLanguage.id => 'Email Perusahaan',
      };

  String get sendRecoveryLink => switch (language) {
        AppLanguage.en => 'Send Recovery Link',
        AppLanguage.zh => '发送重置链接',
        AppLanguage.id => 'Kirim Tautan Pemulihan',
      };

  String get backToLogin => switch (language) {
        AppLanguage.en => 'Back to Login',
        AppLanguage.zh => '返回登录界面',
        AppLanguage.id => 'Kembali ke Login',
      };

  String get emailSentTitle => switch (language) {
        AppLanguage.en => 'Email Sent!',
        AppLanguage.zh => '邮件发送成功！',
        AppLanguage.id => 'Email Terkirim!',
      };

  String get emailSentSubtitle => switch (language) {
        AppLanguage.en => "We've sent a password reset link to:",
        AppLanguage.zh => '我们已将密码重置安全链接发送至：',
        AppLanguage.id => 'Kami telah mengirimkan tautan reset kata sandi ke:',
      };

  String get checkSpamNote => switch (language) {
        AppLanguage.en =>
          "Please check your inbox and follow the instructions. If you don't see it, check your spam folder.",
        AppLanguage.zh => '请查收您的邮箱并按照指引操作。若未收到，请检查垃圾邮件箱。',
        AppLanguage.id =>
          'Silakan periksa kotak masuk Anda. Jika tidak ditemukan, periksa folder spam.',
      };

  String get resendIn => switch (language) {
        AppLanguage.en => 'Resend in',
        AppLanguage.zh => '重新发送还需',
        AppLanguage.id => 'Kirim ulang dalam',
      };

  String get resendEmail => switch (language) {
        AppLanguage.en => 'Resend Email',
        AppLanguage.zh => '重新发送邮件',
        AppLanguage.id => 'Kirim Ulang Email',
      };

  // ==========================================
  // ATTENDANCE HISTORY & DETAIL
  // ==========================================
  String get historyAttendanceTitle => switch (language) {
        AppLanguage.en => 'Attendance History',
        AppLanguage.zh => '考勤历史记录',
        AppLanguage.id => 'Riwayat Absensi',
      };

  String get detailAttendanceTitle => switch (language) {
        AppLanguage.en => 'Attendance Details',
        AppLanguage.zh => '考勤明细详情',
        AppLanguage.id => 'Detail Absensi',
      };

  String get backToDashboard => switch (language) {
        AppLanguage.en => 'Back to Dashboard',
        AppLanguage.zh => '返回工作台',
        AppLanguage.id => 'Kembali ke Dashboard',
      };

  String get statTotalPresent => switch (language) {
        AppLanguage.en => 'Total Present',
        AppLanguage.zh => '出勤总计',
        AppLanguage.id => 'Total Hadir',
      };

  String get statTotalLate => switch (language) {
        AppLanguage.en => 'Total Late',
        AppLanguage.zh => '迟到总计',
        AppLanguage.id => 'Total Terlambat',
      };

  String get statTotalAlpha => switch (language) {
        AppLanguage.en => 'Total Absent',
        AppLanguage.zh => '旷工总计',
        AppLanguage.id => 'Total Alpha',
      };

  String get statTotalPermission => switch (language) {
        AppLanguage.en => 'Total Permission',
        AppLanguage.zh => '事假总计',
        AppLanguage.id => 'Total Izin',
      };

  String get statTotalLeave => switch (language) {
        AppLanguage.en => 'Total Leave',
        AppLanguage.zh => '请假总计',
        AppLanguage.id => 'Total Cuti',
      };

  String get statTotalSick => switch (language) {
        AppLanguage.en => 'Total Sick',
        AppLanguage.zh => '病假总计',
        AppLanguage.id => 'Total Sakit',
      };

  String get filterMonth => switch (language) {
        AppLanguage.en => 'Month',
        AppLanguage.zh => '月份',
        AppLanguage.id => 'Bulan',
      };

  String get filterYear => switch (language) {
        AppLanguage.en => 'Year',
        AppLanguage.zh => '年份',
        AppLanguage.id => 'Tahun',
      };

  String get clockInTime => switch (language) {
        AppLanguage.en => 'Clock In Time',
        AppLanguage.zh => '上班签到时间',
        AppLanguage.id => 'Jam Masuk',
      };

  String get clockOutTimeLabel => switch (language) {
        AppLanguage.en => 'Clock Out Time',
        AppLanguage.zh => '下班签退时间',
        AppLanguage.id => 'Jam Pulang',
      };

  String get clockInLocation => switch (language) {
        AppLanguage.en => 'Clock In Location',
        AppLanguage.zh => '上班打卡地点',
        AppLanguage.id => 'Lokasi Masuk',
      };

  String get clockOutLocation => switch (language) {
        AppLanguage.en => 'Clock Out Location',
        AppLanguage.zh => '下班打卡地点',
        AppLanguage.id => 'Lokasi Pulang',
      };

  String get clockInPhoto => switch (language) {
        AppLanguage.en => 'Clock In Photo',
        AppLanguage.zh => '上班打卡照片',
        AppLanguage.id => 'Foto Masuk',
      };

  String get clockOutPhoto => switch (language) {
        AppLanguage.en => 'Clock Out Photo',
        AppLanguage.zh => '下班打卡照片',
        AppLanguage.id => 'Foto Pulang',
      };

  String get clockInNotes => switch (language) {
        AppLanguage.en => 'Clock In Notes',
        AppLanguage.zh => '上班打卡备注',
        AppLanguage.id => 'Catatan Masuk',
      };

  String get clockOutNotes => switch (language) {
        AppLanguage.en => 'Clock Out Notes',
        AppLanguage.zh => '下班打卡备注',
        AppLanguage.id => 'Catatan Pulang',
      };

  String get noNotes => switch (language) {
        AppLanguage.en => 'No notes provided',
        AppLanguage.zh => '无备注内容',
        AppLanguage.id => 'Tidak ada catatan',
      };

  // ==========================================
  // WORK LEAVE (CUTI & IZIN)
  // ==========================================
  String get workLeaveTitle => switch (language) {
        AppLanguage.en => 'Work Leave & Permission',
        AppLanguage.zh => '请假与休假申请',
        AppLanguage.id => 'Cuti & Izin',
      };

  String get applyLeave => switch (language) {
        AppLanguage.en => 'Apply Leave',
        AppLanguage.zh => '申请休假',
        AppLanguage.id => 'Ajukan Cuti',
      };

  String get leaveStatApproved => switch (language) {
        AppLanguage.en => 'Approved',
        AppLanguage.zh => '已批准',
        AppLanguage.id => 'Disetujui',
      };

  String get leaveStatPending => switch (language) {
        AppLanguage.en => 'Pending',
        AppLanguage.zh => '待审批',
        AppLanguage.id => 'Menunggu',
      };

  String get leaveStatRejected => switch (language) {
        AppLanguage.en => 'Rejected',
        AppLanguage.zh => '已驳回',
        AppLanguage.id => 'Ditolak',
      };

  String get leavePolicyBannerTitle => switch (language) {
        AppLanguage.en => 'Annual & Special Leave Policy',
        AppLanguage.zh => '员工年假与特休守则',
        AppLanguage.id => 'Ketentuan Cuti & Izin Kerja',
      };

  String get leavePolicyBannerSubtitle => switch (language) {
        AppLanguage.en =>
          'Applications must be submitted at least 3 days prior. Medical certificates required for sick leaves.',
        AppLanguage.zh => '请假需至少提前3个工作日提交，病假需附带医院或正规诊所证明。',
        AppLanguage.id =>
          'Pengajuan cuti wajib diajukan minimal H-3 kerja. Lampirkan surat dokter jika mengajukan sakit.',
      };

  String get addLeaveFormTitle => switch (language) {
        AppLanguage.en => 'Leave Application',
        AppLanguage.zh => '提交请假申请',
        AppLanguage.id => 'Pengajuan Cuti / Izin',
      };

  String get selectStartDateUpper => switch (language) {
        AppLanguage.en => 'SELECT START DATE',
        AppLanguage.zh => '选择起始日期',
        AppLanguage.id => 'PILIH TANGGAL MULAI',
      };

  String get selectEndDateUpper => switch (language) {
        AppLanguage.en => 'SELECT END DATE',
        AppLanguage.zh => '选择截止日期',
        AppLanguage.id => 'PILIH TANGGAL SELESAI',
      };

  String get leaveTypeLabel => switch (language) {
        AppLanguage.en => 'Application Type',
        AppLanguage.zh => '申请请假类型',
        AppLanguage.id => 'Jenis Pengajuan',
      };

  String get leaveTypeAnnual => switch (language) {
        AppLanguage.en => 'Annual Leave',
        AppLanguage.zh => '带薪年假',
        AppLanguage.id => 'Cuti Tahunan',
      };

  String get leaveTypePermission => switch (language) {
        AppLanguage.en => 'Permission',
        AppLanguage.zh => '事假 / 特殊假',
        AppLanguage.id => 'Izin Khusus',
      };

  String get leaveTypeSick => switch (language) {
        AppLanguage.en => 'Sick Leave',
        AppLanguage.zh => '病假',
        AppLanguage.id => 'Sakit',
      };

  String get dateRangeLabel => switch (language) {
        AppLanguage.en => 'Date Range',
        AppLanguage.zh => '请假日期区间',
        AppLanguage.id => 'Rentang Tanggal',
      };

  String get startDateLabel => switch (language) {
        AppLanguage.en => 'Start Date',
        AppLanguage.zh => '起始日期',
        AppLanguage.id => 'Tanggal Mulai',
      };

  String get endDateLabel => switch (language) {
        AppLanguage.en => 'End Date',
        AppLanguage.zh => '截止日期',
        AppLanguage.id => 'Tanggal Selesai',
      };

  String get durationLabel => switch (language) {
        AppLanguage.en => 'Total Duration',
        AppLanguage.zh => '合计天数',
        AppLanguage.id => 'Total Durasi',
      };

  String get daysSuffix => switch (language) {
        AppLanguage.en => 'days',
        AppLanguage.zh => '天',
        AppLanguage.id => 'hari',
      };

  String get leaveReasonLabel => switch (language) {
        AppLanguage.en => 'Reason for Leave',
        AppLanguage.zh => '请假详细事由',
        AppLanguage.id => 'Alasan Pengajuan',
      };

  String get leaveReasonHint => switch (language) {
        AppLanguage.en => 'Write your reason clearly...',
        AppLanguage.zh => '清晰、详尽阐述请假事由...',
        AppLanguage.id => 'Tuliskan alasan pengajuan cuti secara jelas...',
      };

  String get attachmentLabel => switch (language) {
        AppLanguage.en => 'Attachment Document',
        AppLanguage.zh => '相关材料附件',
        AppLanguage.id => 'Unggah Dokumen Lampiran',
      };

  String get attachmentSub => switch (language) {
        AppLanguage.en => 'PDF, JPG, or PNG format (Max. 2MB)',
        AppLanguage.zh => '支持 PDF, JPG 或 PNG (不超过 2MB)',
        AppLanguage.id => 'Format PDF, JPG, atau PNG (Maks. 2MB)',
      };

  String get selectAttachmentFile => switch (language) {
        AppLanguage.en => 'Select Attachment File',
        AppLanguage.zh => '选择附件文档',
        AppLanguage.id => 'Pilih Berkas Lampiran',
      };

  String get submitApplication => switch (language) {
        AppLanguage.en => 'Submit Application',
        AppLanguage.zh => '确认提交申请',
        AppLanguage.id => 'Kirim Pengajuan',
      };

  String get submitting => switch (language) {
        AppLanguage.en => 'Submitting...',
        AppLanguage.zh => '提交中...',
        AppLanguage.id => 'Mengirimkan...',
      };

  // ==========================================
  // WARNING LETTERS (SURAT PERINGATAN)
  // ==========================================
  String get warningLettersTitle => switch (language) {
        AppLanguage.en => 'Warning Letters',
        AppLanguage.zh => '员工纪律警告信',
        AppLanguage.id => 'Surat Peringatan',
      };

  String get warningStatTotal => switch (language) {
        AppLanguage.en => 'Total SP',
        AppLanguage.zh => '警告总数',
        AppLanguage.id => 'Total SP',
      };

  String get warningStatActive => switch (language) {
        AppLanguage.en => 'Active SP',
        AppLanguage.zh => '生效中 SP',
        AppLanguage.id => 'SP Aktif',
      };

  String get warningStatCompleted => switch (language) {
        AppLanguage.en => 'Completed SP',
        AppLanguage.zh => '已结案 SP',
        AppLanguage.id => 'SP Selesai',
      };

  String get warningIssuedDate => switch (language) {
        AppLanguage.en => 'Issued Date',
        AppLanguage.zh => '下发日期',
        AppLanguage.id => 'Tanggal Terbit',
      };

  String get warningValidUntil => switch (language) {
        AppLanguage.en => 'Valid Until',
        AppLanguage.zh => '有效期至',
        AppLanguage.id => 'Masa Berlaku',
      };

  String get warningDownloadPdf => switch (language) {
        AppLanguage.en => 'Download SP Document (PDF)',
        AppLanguage.zh => '下载正式警告信 (PDF)',
        AppLanguage.id => 'Unduh Dokumen SP (PDF)',
      };

  String get warningPolicyTitle => switch (language) {
        AppLanguage.en => 'Warning Letter Regulation Guide',
        AppLanguage.zh => '员工纪律警告信规章指引',
        AppLanguage.id => 'Pedoman Regulasi Surat Peringatan',
      };

  String get warningPolicyDialogTitle => switch (language) {
        AppLanguage.en => 'SP Regulation Guide',
        AppLanguage.zh => '纪律守则说明',
        AppLanguage.id => 'Pedoman Regulasi SP',
      };

  String get warningPolicySubtitle => switch (language) {
        AppLanguage.en =>
          'SP remains active for 6 months. Please contact HRD if you have inquiries.',
        AppLanguage.zh => '纪律警告信有效期通常为6个月，如有异议请向人事部门咨询。',
        AppLanguage.id =>
          'Masa pembinaan SP berlaku selama 6 bulan sejak tanggal diterbitkan.',
      };

  String get viewCompanyPolicy => switch (language) {
        AppLanguage.en => 'Read Discipline SOP',
        AppLanguage.zh => '阅读规章指引',
        AppLanguage.id => 'Baca SOP Kedisiplinan',
      };

  // ==========================================
  // PROFILE & EDIT INFORMATION & PASSWORD
  // ==========================================
  String get profileTitle => switch (language) {
        AppLanguage.en => 'Employee Profile',
        AppLanguage.zh => '个人档案中心',
        AppLanguage.id => 'Profil Karyawan',
      };

  String get accountSettings => switch (language) {
        AppLanguage.en => 'Account Settings',
        AppLanguage.zh => '账户设置管理',
        AppLanguage.id => 'Pengaturan Akun',
      };

  String get editInformation => switch (language) {
        AppLanguage.en => 'Edit Information',
        AppLanguage.zh => '编辑个人资料',
        AppLanguage.id => 'Ubah Informasi',
      };

  String get changePasswordTitle => switch (language) {
        AppLanguage.en => 'Change Password',
        AppLanguage.zh => '修改账户密码',
        AppLanguage.id => 'Ubah Kata Sandi',
      };

  String get logoutButton => switch (language) {
        AppLanguage.en => 'Logout',
        AppLanguage.zh => '退出当前账户',
        AppLanguage.id => 'Keluar Akun',
      };

  String get logoutConfirmTitle => switch (language) {
        AppLanguage.en => 'Confirm Logout',
        AppLanguage.zh => '退出登录确认',
        AppLanguage.id => 'Konfirmasi Keluar',
      };

  String get logoutConfirmMessage => switch (language) {
        AppLanguage.en => 'Are you sure you want to log out of Mingda Attendance?',
        AppLanguage.zh => '您确定要退出铭达考勤移动客户端吗？',
        AppLanguage.id =>
          'Apakah Anda yakin ingin keluar dari aplikasi Mingda Absensi?',
      };

  String get employeeCodeLabel => switch (language) {
        AppLanguage.en => 'Code',
        AppLanguage.zh => '工号',
        AppLanguage.id => 'Kode',
      };

  String get departmentLabel => switch (language) {
        AppLanguage.en => 'Department',
        AppLanguage.zh => '部门',
        AppLanguage.id => 'Department',
      };

  String get positionLabel => switch (language) {
        AppLanguage.en => 'Position',
        AppLanguage.zh => '职位',
        AppLanguage.id => 'Jabatan',
      };

  String get phoneLabel => switch (language) {
        AppLanguage.en => 'Phone',
        AppLanguage.zh => '电话',
        AppLanguage.id => 'Phone',
      };

  String get personalDataSection => switch (language) {
        AppLanguage.en => 'Personal Information',
        AppLanguage.zh => '个人资料信息',
        AppLanguage.id => 'Informasi Karyawan',
      };

  String get fullNameLabel => switch (language) {
        AppLanguage.en => 'Full Name',
        AppLanguage.zh => '员工全名',
        AppLanguage.id => 'Nama Lengkap',
      };

  String get phoneNumberLabel => switch (language) {
        AppLanguage.en => 'Phone Number',
        AppLanguage.zh => '联系电话',
        AppLanguage.id => 'Nomor Telepon',
      };

  String get saveChanges => switch (language) {
        AppLanguage.en => 'Save Changes',
        AppLanguage.zh => '保存修改内容',
        AppLanguage.id => 'Simpan Perubahan',
      };

  String get changePhotoModalTitle => switch (language) {
        AppLanguage.en => 'Change Profile Photo',
        AppLanguage.zh => '更改个人头像',
        AppLanguage.id => 'Ubah Foto Profil',
      };

  String get takePhotoCamera => switch (language) {
        AppLanguage.en => 'Take Photo from Camera',
        AppLanguage.zh => '使用相机现场拍照',
        AppLanguage.id => 'Ambil Foto dari Kamera',
      };

  String get chooseFromGallery => switch (language) {
        AppLanguage.en => 'Choose from Gallery',
        AppLanguage.zh => '从手机相册选择',
        AppLanguage.id => 'Pilih dari Galeri',
      };

  String get useMonogramAvatar => switch (language) {
        AppLanguage.en => 'Use Monogram Avatar',
        AppLanguage.zh => '使用姓名首字母头像',
        AppLanguage.id => 'Gunakan Inisial Avatar',
      };

  String get lockedByHrdNotice => switch (language) {
        AppLanguage.en => 'Employment Data (Locked by HRD)',
        AppLanguage.zh => '工作编制数据（由人事处统一归档锁定）',
        AppLanguage.id => 'Data Kepegawaian (Terkunci)',
      };

  String get currentPasswordLabel => switch (language) {
        AppLanguage.en => 'Current Password',
        AppLanguage.zh => '当前正在使用的密码',
        AppLanguage.id => 'Kata Sandi Saat Ini',
      };

  String get currentPasswordHint => switch (language) {
        AppLanguage.en => 'Enter your current password',
        AppLanguage.zh => '输入当前登录密码',
        AppLanguage.id => 'Masukkan kata sandi saat ini',
      };

  String get newPasswordLabel => switch (language) {
        AppLanguage.en => 'New Password',
        AppLanguage.zh => '设置全新密码',
        AppLanguage.id => 'Kata Sandi Baru',
      };

  String get newPasswordHint => switch (language) {
        AppLanguage.en => 'Enter new password (min. 8 chars)',
        AppLanguage.zh => '输入新密码（至少8位）',
        AppLanguage.id => 'Masukkan kata sandi baru (min. 8 karakter)',
      };

  String get confirmPasswordLabel => switch (language) {
        AppLanguage.en => 'Confirm New Password',
        AppLanguage.zh => '重复新密码确认',
        AppLanguage.id => 'Konfirmasi Kata Sandi Baru',
      };

  String get confirmPasswordHint => switch (language) {
        AppLanguage.en => 'Re-enter your new password',
        AppLanguage.zh => '再次输入新密码',
        AppLanguage.id => 'Ulangi kata sandi baru Anda',
      };

  String get criteriaMin8 => switch (language) {
        AppLanguage.en => 'At least 8 characters',
        AppLanguage.zh => '长度不少于 8 位字符',
        AppLanguage.id => 'Minimal 8 karakter',
      };

  String get criteriaDifferent => switch (language) {
        AppLanguage.en => 'Different from current password',
        AppLanguage.zh => '与当前原密码不同',
        AppLanguage.id => 'Berbeda dari kata sandi saat ini',
      };

  String get criteriaMatch => switch (language) {
        AppLanguage.en => 'Passwords match',
        AppLanguage.zh => '确认密码完全一致',
        AppLanguage.id => 'Konfirmasi kata sandi sesuai',
      };

  String get updatePasswordButton => switch (language) {
        AppLanguage.en => 'Update Password',
        AppLanguage.zh => '确认更新密码',
        AppLanguage.id => 'Perbarui Kata Sandi',
      };

  String get passwordUpdatedSuccess => switch (language) {
        AppLanguage.en => 'Password successfully updated!',
        AppLanguage.zh => '账户密码修改成功！',
        AppLanguage.id => 'Kata sandi berhasil diperbarui!',
      };

  // ==========================================
  // NOTIFICATIONS
  // ==========================================
  String get notificationsTitle => switch (language) {
        AppLanguage.en => 'Notifications',
        AppLanguage.zh => '消息中心',
        AppLanguage.id => 'Notifikasi',
      };

  String get tabAllNotifications => switch (language) {
        AppLanguage.en => 'All',
        AppLanguage.zh => '全部消息',
        AppLanguage.id => 'Semua',
      };

  String get tabAnnouncements => switch (language) {
        AppLanguage.en => 'Announcements',
        AppLanguage.zh => '公司公告',
        AppLanguage.id => 'Pengumuman',
      };

  String get tabActivities => switch (language) {
        AppLanguage.en => 'Activities',
        AppLanguage.zh => '个人动态',
        AppLanguage.id => 'Aktivitas',
      };

  String get markAllRead => switch (language) {
        AppLanguage.en => 'Mark Read',
        AppLanguage.zh => '全部已读',
        AppLanguage.id => 'Tandai Dibaca',
      };

  String get allNotificationsMarkedRead => switch (language) {
        AppLanguage.en => 'All notifications marked as read',
        AppLanguage.zh => '所有通知已全部标为已读',
        AppLanguage.id => 'Semua notifikasi ditandai telah dibaca',
      };

  String get noNotificationsYet => switch (language) {
        AppLanguage.en => 'No notifications yet',
        AppLanguage.zh => '暂无任何消息记录',
        AppLanguage.id => 'Belum ada notifikasi',
      };

  // ==========================================
  // PROFILE / EDIT INFORMATION ENHANCEMENTS
  // ==========================================
  String get activeEmployeeBadge => switch (language) {
        AppLanguage.en => 'Active Employee',
        AppLanguage.zh => '在职员工',
        AppLanguage.id => 'Karyawan Aktif',
      };

  String get tapToChangePhoto => switch (language) {
        AppLanguage.en => 'Tap icon to change photo',
        AppLanguage.zh => '点击图标更换个人头像',
        AppLanguage.id => 'Ketuk icon untuk mengubah foto',
      };

  String get profilePhotoSelectedSuccess => switch (language) {
        AppLanguage.en => 'New profile photo selected successfully.',
        AppLanguage.zh => '新头像选择成功。',
        AppLanguage.id => 'Foto profil baru berhasil dipilih.',
      };

  String get profileUpdateSuccessMessage => switch (language) {
        AppLanguage.en => 'Profile information updated successfully!',
        AppLanguage.zh => '个人资料已成功更新！',
        AppLanguage.id => 'Informasi profil berhasil diperbarui!',
      };

  String get fullNameRequired => switch (language) {
        AppLanguage.en => 'Full name is required',
        AppLanguage.zh => '员工全名必填',
        AppLanguage.id => 'Nama lengkap wajib diisi',
      };

  String get fullNameTooShort => switch (language) {
        AppLanguage.en => 'Name is too short',
        AppLanguage.zh => '名字长度过短',
        AppLanguage.id => 'Nama terlalu pendek',
      };

  String get phoneRequired => switch (language) {
        AppLanguage.en => 'Phone number is required',
        AppLanguage.zh => '联系电话必填',
        AppLanguage.id => 'Nomor telepon wajib diisi',
      };

  String get phoneInvalid => switch (language) {
        AppLanguage.en => 'Invalid phone number',
        AppLanguage.zh => '联系电话格式无效',
        AppLanguage.id => 'Nomor telepon tidak valid',
      };

  String get emailRequired => switch (language) {
        AppLanguage.en => 'Email address is required',
        AppLanguage.zh => '电子邮箱必填',
        AppLanguage.id => 'Alamat email wajib diisi',
      };

  String get emailInvalid => switch (language) {
        AppLanguage.en => 'Invalid email address',
        AppLanguage.zh => '电子邮箱格式不正确',
        AppLanguage.id => 'Format email tidak valid',
      };

  String get canEditBadge => switch (language) {
        AppLanguage.en => 'Editable',
        AppLanguage.zh => '支持修改',
        AppLanguage.id => 'Dapat Diubah',
      };

  String get editablePersonalSubtitle => switch (language) {
        AppLanguage.en =>
            'Profile & active contact details that can be updated',
        AppLanguage.zh => '可随时更新的个人联系方式信息',
        AppLanguage.id => 'Data profil & kontak aktif yang dapat diperbarui',
      };

  String get hrdNoticeCard => switch (language) {
        AppLanguage.en =>
          'Employment data (Code, Department, Position, Shift) is managed and locked by HRD. Please contact HR if any discrepancy occurs.',
        AppLanguage.zh => '编制数据（工号、部门、职位、班次）由人事处统一归档锁定。如有疑问请联系人事部门。',
        AppLanguage.id =>
          'Data kepegawaian (Kode, Departemen, Jabatan, Shift) dikunci & dikelola langsung oleh HRD PT Mingda. Silakan hubungi Personalia jika ada ketidaksesuaian.',
      };

  String get wantToChangePassword => switch (language) {
        AppLanguage.en => 'Want to Change Password?',
        AppLanguage.zh => '需要修改账户密码？',
        AppLanguage.id => 'Ingin Memperbarui Kata Sandi?',
      };

  String get wantToChangePasswordSub => switch (language) {
        AppLanguage.en =>
          'Use the "Change Password" menu on the Profile page to update your login password.',
        AppLanguage.zh => '请在个人档案中使用“修改密码”功能进行账户安全凭证更新。',
        AppLanguage.id =>
          'Gunakan menu "Ubah Password" pada halaman Profil untuk mengganti kata sandi login Anda.',
      };

  String get saving => switch (language) {
        AppLanguage.en => 'Saving...',
        AppLanguage.zh => '保存中...',
        AppLanguage.id => 'Menyimpan...',
      };

  String get fullNameHint => switch (language) {
        AppLanguage.en => 'Enter your full name',
        AppLanguage.zh => '输入您的全名',
        AppLanguage.id => 'Masukkan nama lengkap',
      };

  String get photoFormatHint => switch (language) {
        AppLanguage.en => 'JPG / PNG format (Max. 2MB)',
        AppLanguage.zh => 'JPG / PNG 格式（最大 2MB）',
        AppLanguage.id => 'Format JPG / PNG (Maks. 2MB)',
      };

  String get takePhotoCameraSub => switch (language) {
        AppLanguage.en => 'Use device camera for recent official photo',
        AppLanguage.zh => '使用设备摄像头即时拍摄官方证件照',
        AppLanguage.id => 'Gunakan kamera perangkat untuk foto resmi terbaru',
      };

  String get chooseFromGallerySub => switch (language) {
        AppLanguage.en => 'Select plain-background photo from storage',
        AppLanguage.zh => '从手机存储中选择清晰正装照片',
        AppLanguage.id => 'Pilih foto berlatar polos dari media penyimpanan',
      };

  String get useMonogramAvatarSub => switch (language) {
        AppLanguage.en => 'Display your official initials monogram',
        AppLanguage.zh => '显示姓名首字母缩写作为头像',
        AppLanguage.id => 'Tampilkan monogram inisial nama resmi Anda',
      };

  String get locked => switch (language) {
        AppLanguage.en => 'Locked',
        AppLanguage.zh => '已锁定',
        AppLanguage.id => 'Terkunci',
      };

  // ==========================================
  // CHANGE PASSWORD ENHANCEMENTS
  // ==========================================
  String get passwordSecurityTitle => switch (language) {
        AppLanguage.en => 'Password Security',
        AppLanguage.zh => '账户密码安全',
        AppLanguage.id => 'Keamanan Kata Sandi',
      };

  String get passwordSecuritySubtitle => switch (language) {
        AppLanguage.en =>
          'Update your account password periodically to protect your privacy.',
        AppLanguage.zh => '定期更新账户密码以全方位保护您的隐私与数据安全。',
        AppLanguage.id =>
          'Perbarui kata sandi akun secara berkala untuk melindungi data privasi Anda.',
      };

  String get passwordFormTitle => switch (language) {
        AppLanguage.en => 'Password Form',
        AppLanguage.zh => '密码表单',
        AppLanguage.id => 'Formulir Kata Sandi',
      };

  String get passwordFormSubtitle => switch (language) {
        AppLanguage.en => 'Ensure your new password meets security standards',
        AppLanguage.zh => '请确保新密码符合企业级安全强度规范',
        AppLanguage.id => 'Pastikan kata sandi baru memenuhi standar keamanan',
      };

  String get currentPasswordRequired => switch (language) {
        AppLanguage.en => 'Current password is required',
        AppLanguage.zh => '当前原密码必填',
        AppLanguage.id => 'Kata sandi saat ini wajib diisi',
      };

  String get newPasswordRequired => switch (language) {
        AppLanguage.en => 'New password is required',
        AppLanguage.zh => '全新密码必填',
        AppLanguage.id => 'Kata sandi baru wajib diisi',
      };

  String get newPasswordMin8 => switch (language) {
        AppLanguage.en => 'New password must be at least 8 characters',
        AppLanguage.zh => '全新密码长度至少需要 8 个字符',
        AppLanguage.id => 'Kata sandi baru minimal 8 karakter',
      };

  String get newPasswordMustBeDifferent => switch (language) {
        AppLanguage.en => 'New password cannot be the same as current password',
        AppLanguage.zh => '新密码不能与当前原密码相同',
        AppLanguage.id =>
          'Kata sandi baru tidak boleh sama dengan kata sandi saat ini',
      };

  String get confirmPasswordRequired => switch (language) {
        AppLanguage.en => 'Password confirmation is required',
        AppLanguage.zh => '重复新密码确认必填',
        AppLanguage.id => 'Konfirmasi kata sandi wajib diisi',
      };

  String get confirmPasswordMustMatch => switch (language) {
        AppLanguage.en => 'Password confirmation does not match new password',
        AppLanguage.zh => '两次输入的新密码不一致',
        AppLanguage.id =>
          'Konfirmasi kata sandi tidak cocok dengan kata sandi baru',
      };

  String get securityCriteriaTitle => switch (language) {
        AppLanguage.en => 'Password Security Criteria:',
        AppLanguage.zh => '密码安全合规标准：',
        AppLanguage.id => 'Kriteria Keamanan Kata Sandi:',
      };

  String get passwordChangeNotice => switch (language) {
        AppLanguage.en =>
          'After successfully updating your password, you must use the new password to log in next time.',
        AppLanguage.zh => '成功更改密码后，下次登录系统时请使用全新的安全密码。',
        AppLanguage.id =>
          'Setelah berhasil mengubah kata sandi, Anda harus menggunakan kata sandi baru untuk login pada sesi berikutnya.',
      };

  String get saveNewPasswordButton => switch (language) {
        AppLanguage.en => 'Save New Password',
        AppLanguage.zh => '保存全新密码',
        AppLanguage.id => 'Simpan Kata Sandi Baru',
      };

  // ==========================================
  // NOTIFICATION ENHANCEMENTS
  // ==========================================
  String get noAnnouncementsYet => switch (language) {
        AppLanguage.en => 'No Announcements',
        AppLanguage.zh => '暂无公告',
        AppLanguage.id => 'Tidak Ada Pengumuman',
      };

  String get noAnnouncementsDesc => switch (language) {
        AppLanguage.en =>
          'There are no official notices or broadcasts from the company yet.',
        AppLanguage.zh => '公司目前尚未发布任何正式通知或广播公告。',
        AppLanguage.id =>
          'Belum ada surat edaran atau siaran pengumuman resmi dari perusahaan.',
      };

  String get noActivitiesYet => switch (language) {
        AppLanguage.en => 'No Activities',
        AppLanguage.zh => '暂无动态',
        AppLanguage.id => 'Tidak Ada Aktivitas',
      };

  String get noActivitiesDesc => switch (language) {
        AppLanguage.en =>
          'Updates on leave status, attendance, and payslips will appear here.',
        AppLanguage.zh => '请假进度、考勤打卡以及薪资条更新记录将在此呈现。',
        AppLanguage.id =>
          'Pembaruan status cuti, presensi, dan slip gaji akan muncul di sini.',
      };

  String get noNotificationsDesc => switch (language) {
        AppLanguage.en =>
          'All your official announcements and latest attendance activities will appear here.',
        AppLanguage.zh => '您所有的官方公告和最新考勤动态都将显示在这里。',
        AppLanguage.id =>
          'Semua pengumuman resmi dan aktivitas presensi terbaru Anda akan tampil di sini.',
      };

  // ==========================================
  // ATTENDANCE HISTORY & DETAIL ENHANCEMENTS
  // ==========================================
  String get emptyData => switch (language) {
        AppLanguage.en => 'No data available',
        AppLanguage.zh => '暂无数据记录',
        AppLanguage.id => 'Data kosong',
      };

  String get failedToGetProfile => switch (language) {
        AppLanguage.en => 'Failed to load profile',
        AppLanguage.zh => '获取个人资料失败',
        AppLanguage.id => 'Gagal memuat profil',
      };

  String get failedToLoadData => switch (language) {
        AppLanguage.en => 'Failed to load data. Please try again.',
        AppLanguage.zh => '加载数据失败，请重试。',
        AppLanguage.id => 'Gagal memuat data. Coba lagi.',
      };

  String get timeInformation => switch (language) {
        AppLanguage.en => 'Time Information',
        AppLanguage.zh => '考勤时间明细',
        AppLanguage.id => 'Informasi Waktu',
      };

  String get gpsInformation => switch (language) {
        AppLanguage.en => 'GPS Information',
        AppLanguage.zh => '定位打卡信息',
        AppLanguage.id => 'Informasi GPS',
      };

  String get inInformation => switch (language) {
        AppLanguage.en => 'Check In Info',
        AppLanguage.zh => '签到状态',
        AppLanguage.id => 'Informasi Masuk',
      };

  String get outLocation => switch (language) {
        AppLanguage.en => 'Check Out Location',
        AppLanguage.zh => '签退地点',
        AppLanguage.id => 'Lokasi Keluar',
      };

  String get notes => switch (language) {
        AppLanguage.en => 'Notes',
        AppLanguage.zh => '打卡备注',
        AppLanguage.id => 'Catatan',
      };

  // ==========================================
  // WORK LEAVE & ADD LEAVE ENHANCEMENTS
  // ==========================================
  String get leaveApplicationsHistory => switch (language) {
        AppLanguage.en => 'Leave Application History',
        AppLanguage.zh => '休假申请记录',
        AppLanguage.id => 'Riwayat Pengajuan Cuti',
      };

  String get createLeaveApplication => switch (language) {
        AppLanguage.en => 'New Leave Application',
        AppLanguage.zh => '创建休假申请',
        AppLanguage.id => 'Buat Pengajuan Baru',
      };

  String get noLeaveHistory => switch (language) {
        AppLanguage.en => 'No leave applications yet',
        AppLanguage.zh => '暂无请假历史记录',
        AppLanguage.id => 'Belum ada riwayat pengajuan cuti',
      };

  String get dateRange => switch (language) {
        AppLanguage.en => 'Date Range',
        AppLanguage.zh => '日期范围',
        AppLanguage.id => 'Rentang Tanggal',
      };

  String get start => switch (language) {
        AppLanguage.en => 'Start',
        AppLanguage.zh => '开始',
        AppLanguage.id => 'Mulai',
      };

  String get end => switch (language) {
        AppLanguage.en => 'End',
        AppLanguage.zh => '结束',
        AppLanguage.id => 'Selesai',
      };

  String get totalDuration => switch (language) {
        AppLanguage.en => 'Total Duration:',
        AppLanguage.zh => '申请总时长：',
        AppLanguage.id => 'Total Durasi:',
      };

  String get workingDays => switch (language) {
        AppLanguage.en => 'Working Days',
        AppLanguage.zh => '工作日',
        AppLanguage.id => 'Hari Kerja',
      };

  String get reasonLabel => switch (language) {
        AppLanguage.en => 'Reason / Remarks',
        AppLanguage.zh => '请假原因与详细说明',
        AppLanguage.id => 'Keterangan / Alasan',
      };

  String get reasonHint => switch (language) {
        AppLanguage.en =>
          'Provide full reason for leave or permission request...',
        AppLanguage.zh => '清晰、详尽阐述请假或报备事由...',
        AppLanguage.id =>
          'Tuliskan alasan lengkap permohonan cuti atau izin...',
      };

  String get reasonRequired => switch (language) {
        AppLanguage.en => 'Reason for leave is required.',
        AppLanguage.zh => '请假事由必填。',
        AppLanguage.id => 'Alasan pengajuan wajib diisi.',
      };

  String get reasonMin5 => switch (language) {
        AppLanguage.en => 'Reason must be at least 5 characters.',
        AppLanguage.zh => '请假事由至少需要 5 个字。',
        AppLanguage.id => 'Keterangan minimal 5 karakter.',
      };

  String get supportingDocuments => switch (language) {
        AppLanguage.en => 'Supporting Documents',
        AppLanguage.zh => '证明材料文档',
        AppLanguage.id => 'Dokumen Pendukung',
      };

  String get doctorCertRequired => switch (language) {
        AppLanguage.en => '(Medical certificate required)',
        AppLanguage.zh => '（须上传医生诊断证明）',
        AppLanguage.id => '(Wajib surat dokter)',
      };

  String get optional => switch (language) {
        AppLanguage.en => '(Optional)',
        AppLanguage.zh => '（选填）',
        AppLanguage.id => '(Opsional)',
      };

  String get tapToChangeFile => switch (language) {
        AppLanguage.en => 'Tap to change file',
        AppLanguage.zh => '点击更换附件文件',
        AppLanguage.id => 'Ketuk untuk mengganti berkas',
      };

  String get doctorCertWarning => switch (language) {
        AppLanguage.en =>
          'For sick leave, a medical certificate must be attached.',
        AppLanguage.zh => '申请病假必须附带正规医疗机构出具的诊断书。',
        AppLanguage.id =>
          'Untuk izin sakit, surat dokter / bukti medis wajib dilampirkan.',
      };

  String get leaveSubmitSuccess => switch (language) {
        AppLanguage.en =>
          'Leave application submitted successfully! (Status: Pending)',
        AppLanguage.zh => '休假申请提交成功！（状态：待审批）',
        AppLanguage.id => 'Pengajuan cuti berhasil dibuat! (Status: Menunggu)',
      };

  // ==========================================
  // WARNING LETTERS ENHANCEMENTS
  // ==========================================
  String get totalSpReceivedUpper => switch (language) {
        AppLanguage.en => 'TOTAL WARNINGS RECEIVED',
        AppLanguage.zh => '收到纪律警告总计',
        AppLanguage.id => 'TOTAL SP DITERIMA',
      };

  String get spActiveUpper => switch (language) {
        AppLanguage.en => 'ACTIVE WARNINGS',
        AppLanguage.zh => '生效中警告',
        AppLanguage.id => 'SP AKTIF',
      };

  String get spCompletedUpper => switch (language) {
        AppLanguage.en => 'COMPLETED WARNINGS',
        AppLanguage.zh => '已结案警告',
        AppLanguage.id => 'SP SELESAI',
      };

  String get downloadingPhysicalFile => switch (language) {
        AppLanguage.en => 'Downloading file',
        AppLanguage.zh => '正在下载文档',
        AppLanguage.id => 'Mengunduh berkas fisik',
      };

  String get noMatchingSpFound => switch (language) {
        AppLanguage.en => 'No warning letters match the filter',
        AppLanguage.zh => '没有符合当前筛选条件的警告信',
        AppLanguage.id => 'Tidak ada Surat Peringatan',
      };

  String get noMatchingSpSubtitle => switch (language) {
        AppLanguage.en => 'No warning letters found matching selected filters.',
        AppLanguage.zh => '未找到符合所选筛选条件的纪律警告信。',
        AppLanguage.id =>
          'Tidak ditemukan SP yang sesuai dengan filter yang dipilih.',
      };

  String get leaveStatUsed => switch (language) {
        AppLanguage.en => 'Leave Used',
        AppLanguage.zh => '已用假期',
        AppLanguage.id => 'Cuti Terpakai',
      };

  String get allApplications => switch (language) {
        AppLanguage.en => 'All Applications',
        AppLanguage.zh => '全部申请',
        AppLanguage.id => 'Semua Pengajuan',
      };

  String get leaveBannerCategory => switch (language) {
        AppLanguage.en => 'LEAVE & HOLIDAYS',
        AppLanguage.zh => '休假与节假日',
        AppLanguage.id => 'CUTI & LIBUR',
      };

  String get leaveBannerTitle => switch (language) {
        AppLanguage.en => 'Joint Holiday Announcement 2026',
        AppLanguage.zh => '2026年公共假期通知',
        AppLanguage.id => 'Pengumuman Cuti Bersama 2026',
      };

  String get leaveBannerSubtitle => switch (language) {
        AppLanguage.en =>
          'Employee national holiday & joint leave operational schedule.',
        AppLanguage.zh => '员工法定节假日与公休排班安排。',
        AppLanguage.id =>
          'Jadwal operasional libur nasional & cuti bersama karyawan.',
      };

  String get noLeaveWithStatusPrefix => switch (language) {
        AppLanguage.en => 'No leave applications with status',
        AppLanguage.zh => '没有此状态的请假记录：',
        AppLanguage.id => 'Tidak ada pengajuan cuti berstatus',
      };

  String get applicationId => switch (language) {
        AppLanguage.en => 'Application ID',
        AppLanguage.zh => '申请编号',
        AppLanguage.id => 'ID Pengajuan',
      };

  String get applicationPeriod => switch (language) {
        AppLanguage.en => 'Application Period',
        AppLanguage.zh => '申请时段',
        AppLanguage.id => 'Periode Pengajuan',
      };

  String get toWord => switch (language) {
        AppLanguage.en => 'to',
        AppLanguage.zh => '至',
        AppLanguage.id => 's.d',
      };

  String get downloadPdf => switch (language) {
        AppLanguage.en => 'Download PDF',
        AppLanguage.zh => '下载 PDF',
        AppLanguage.id => 'Unduh PDF',
      };

  String get regulationAndCompliance => switch (language) {
        AppLanguage.en => 'REGULATION & COMPLIANCE',
        AppLanguage.zh => '规章与合规',
        AppLanguage.id => 'REGULASI & KEPATUHAN',
      };

  String get iUnderstand => switch (language) {
        AppLanguage.en => 'I Understand',
        AppLanguage.zh => '我已了解',
        AppLanguage.id => 'Saya Mengerti',
      };

  String get allWord => switch (language) {
        AppLanguage.en => 'All',
        AppLanguage.zh => '全部',
        AppLanguage.id => 'Semua',
      };

  String get selectStatus => switch (language) {
        AppLanguage.en => 'Select Status',
        AppLanguage.zh => '选择状态',
        AppLanguage.id => 'Pilih Status',
      };

  String get allStatuses => switch (language) {
        AppLanguage.en => 'All Statuses',
        AppLanguage.zh => '全部状态',
        AppLanguage.id => 'Semua Status',
      };

  // ==========================================
  // FEEDBACK TOAST
  // ==========================================
  String get languageChangedSuccess => switch (language) {
        AppLanguage.en => 'Language changed to English',
        AppLanguage.zh => '语言已切换为简体中文',
        AppLanguage.id => 'Bahasa berhasil diubah ke Bahasa Indonesia',
      };

  String get allMonths => switch (language) {
        AppLanguage.en => 'All Months',
        AppLanguage.zh => '全部月份',
        AppLanguage.id => 'Semua Bulan',
      };

  String get allAttendance => switch (language) {
        AppLanguage.en => 'All Attendance',
        AppLanguage.zh => '全部考勤',
        AppLanguage.id => 'Semua Kehadiran',
      };

  String get datePickerApply => switch (language) {
        AppLanguage.en => 'Apply',
        AppLanguage.zh => '确认应用',
        AppLanguage.id => 'Terapkan',
      };

  String get today => switch (language) {
        AppLanguage.en => 'Today',
        AppLanguage.zh => '今天',
        AppLanguage.id => 'Hari Ini',
      };

  String get yesterday => switch (language) {
        AppLanguage.en => 'Yesterday',
        AppLanguage.zh => '昨天',
        AppLanguage.id => 'Kemarin',
      };

  String get earlier => switch (language) {
        AppLanguage.en => 'Earlier',
        AppLanguage.zh => '较早',
        AppLanguage.id => 'Terdahulu',
      };

  String get last7Days => switch (language) {
        AppLanguage.en => 'Last 7 Days',
        AppLanguage.zh => '近 7 天',
        AppLanguage.id => '7 Hari Terakhir',
      };

  String get welcomeGreeting => switch (language) {
        AppLanguage.en => 'Welcome 👋',
        AppLanguage.zh => '欢迎您 👋',
        AppLanguage.id => 'Selamat Datang 👋',
      };

  String get spRegulationsSubtitle => switch (language) {
        AppLanguage.en => 'Company Regulations (Chapter IX - Discipline)',
        AppLanguage.zh => '公司员工守则（第九章 - 纪律处分）',
        AppLanguage.id => 'PP PT Mingda (Bab IX - Disiplin)',
      };

  String get openRelatedPage => switch (language) {
        AppLanguage.en => 'Open Related Page',
        AppLanguage.zh => '前往相关页面',
        AppLanguage.id => 'Buka Halaman Terkait',
      };

  String get officialAnnouncementBadge => switch (language) {
        AppLanguage.en => 'OFFICIAL ANNOUNCEMENT',
        AppLanguage.zh => '企业官方公告',
        AppLanguage.id => 'PENGUMUMAN RESMI',
      };

  String get employeeActivityBadge => switch (language) {
        AppLanguage.en => 'EMPLOYEE ACTIVITY',
        AppLanguage.zh => '员工个人动态',
        AppLanguage.id => 'AKTIVITAS KARYAWAN',
      };

  String get understood => switch (language) {
        AppLanguage.en => 'Understood',
        AppLanguage.zh => '我已了解',
        AppLanguage.id => 'Mengerti',
      };

  String get spSection1Title => switch (language) {
        AppLanguage.en => 'Warning Letter Levels',
        AppLanguage.zh => '警告信处分级别',
        AppLanguage.id => 'Tingkatan Surat Peringatan',
      };

  String get spSection1Content => switch (language) {
        AppLanguage.en =>
          '• SP-1: Minor disciplinary breach or repeated tardiness (valid 6 months).\n'
          '• SP-2: Issued if a violation occurs while SP-1 is active (valid 6 months).\n'
          '• SP-3: Final warning letter before board review / termination consideration.',
        AppLanguage.zh =>
          '• SP-1: 轻微违纪或多次迟到（有效期6个月）。\n'
          '• SP-2: 在SP-1生效期内再度发生违纪（有效期6个月）。\n'
          '• SP-3: 最终书面警告信，移交管理层复核或做解除劳动合同处理。',
        AppLanguage.id =>
          '• SP-1: Pelanggaran disiplin ringan atau keterlambatan berulang (berlaku 6 bulan).\n'
          '• SP-2: Diterbitkan bila terjadi pelanggaran saat SP-1 masih aktif (berlaku 6 bulan).\n'
          '• SP-3: Surat Peringatan Terakhir sebelum pertimbangan terminasi/sidang direksi.',
      };

  String get spSection2Title => switch (language) {
        AppLanguage.en => 'Validity Period & Expiration',
        AppLanguage.zh => '有效期限与自动结案',
        AppLanguage.id => 'Masa Berlaku & Pemutihan',
      };

  String get spSection2Content => switch (language) {
        AppLanguage.en =>
          'Each SP level is valid for 6 (six) months from issuance date. '
          'If no further violations occur during this period, the SP status automatically expires (Completed).',
        AppLanguage.zh =>
          '各级别警告信有效期自签发之日起计算为6个月。'
          '若员工在考核期内未再出现违规行为，到期后自动失效结案。',
        AppLanguage.id =>
          'Masa berlaku setiap tingkat SP adalah 6 (enam) bulan sejak tanggal diterbitkan. '
          'Apabila karyawan tidak melakukan pelanggaran dalam kurun waktu tersebut, status SP otomatis kadaluarsa (Selesai).',
      };

  String get spSection3Title => switch (language) {
        AppLanguage.en => 'Right to Clarification & HR Counseling',
        AppLanguage.zh => '申诉澄清权与人事面谈',
        AppLanguage.id => 'Hak Klarifikasi & Konseling HRD',
      };

  String get spSection3Content => switch (language) {
        AppLanguage.en =>
          'Employees have the right to submit a written clarification or consult with HRD '
          'within a maximum of 7 (seven) working days after issuance.',
        AppLanguage.zh =>
          '员工在警告信下发之日起 7 个工作日内，有权向人力资源部提交书面申诉或预约面谈辅导。',
        AppLanguage.id =>
          'Karyawan berhak mengajukan klarifikasi tertulis atau berkonsultasi dengan Divisi HRD '
          'maksimal 7 (tujuh) hari kerja setelah surat diterbitkan untuk proses pembinaan.',
      };

  String notifMinAgo(int minutes) => switch (language) {
        AppLanguage.en => '${minutes}m ago',
        AppLanguage.zh => '$minutes分钟前',
        AppLanguage.id => '$minutes mnt lalu',
      };

  String notifHoursAgo(int hours) => switch (language) {
        AppLanguage.en => '${hours}h ago',
        AppLanguage.zh => '$hours小时前',
        AppLanguage.id => '$hours jam lalu',
      };

  String notifDaysAgo(int days) => switch (language) {
        AppLanguage.en => '${days}d ago',
        AppLanguage.zh => '$days天前',
        AppLanguage.id => '$days hari lalu',
      };

  String get notifJustNow => switch (language) {
        AppLanguage.en => 'Just now',
        AppLanguage.zh => '刚刚',
        AppLanguage.id => 'Baru saja',
      };

  String get notifTagAnnouncement => switch (language) {
        AppLanguage.en => 'ANNOUNCEMENT',
        AppLanguage.zh => '公司公告',
        AppLanguage.id => 'PENGUMUMAN',
      };

  String get notifTagLeaveApproved => switch (language) {
        AppLanguage.en => 'LEAVE APPROVED',
        AppLanguage.zh => '休假已批准',
        AppLanguage.id => 'CUTI DISETUJUI',
      };

  String get notifTagLeaveRejected => switch (language) {
        AppLanguage.en => 'LEAVE REJECTED',
        AppLanguage.zh => '休假已驳回',
        AppLanguage.id => 'CUTI DITOLAK',
      };

  String get notifTagAttendance => switch (language) {
        AppLanguage.en => 'ATTENDANCE',
        AppLanguage.zh => '考勤提醒',
        AppLanguage.id => 'PRESENSI',
      };

  String get notifTagPayslip => switch (language) {
        AppLanguage.en => 'PAYSLIP',
        AppLanguage.zh => '工资单',
        AppLanguage.id => 'SLIP GAJI',
      };

  String get notifTagWarning => switch (language) {
        AppLanguage.en => 'WARNING LETTER',
        AppLanguage.zh => '纪律警告',
        AppLanguage.id => 'SURAT PERINGATAN',
      };

  static AppTranslations of(AppLanguage lang) => AppTranslations(lang);
}
