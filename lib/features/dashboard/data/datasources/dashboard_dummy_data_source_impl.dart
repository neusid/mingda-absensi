import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';
import 'package:mingda_app/features/dashboard/data/models/profile_model.dart';

class DashboardDummyDataSourceImpl implements DashboardRemoteDataSource {
  static ProfileModel _currentProfile = const ProfileModel(
    id: 1,
    employeeCode: 'MD-2024-001',
    fingerspotPin: '1001',
    nik: '3578012345670001',
    name: 'Malik Ibrahim',
    gender: 'Laki-laki',
    birthPlace: 'Surabaya',
    birthDate: '2000-05-15',
    maritalStatus: 'Belum Menikah',
    agama: 'Islam',
    bangsa: 'Indonesia',
    statusKependudukan: 'WNI',
    tanggunganAnak: 0,
    namaIbuKandung: 'Fatimah',
    ktp: '3578012345670001',
    kartuKeluarga: '3578012345670002',
    departmentId: 1,
    subDepartmentId: 1,
    subDepartmentOld: null,
    positionId: 1,
    joinDate: '2023-01-15',
    employmentStatus: 'Karyawan Tetap',
    serikat: 'Tidak',
    lulusanSekolah: 'S1 Teknik Informatika',
    workScheduleId: 1,
    supervisorId: null,
    salaryBase: 7500000.0,
    bank: 'BCA',
    nomorRekening: '8291029381',
    taxNpwp: '93.812.391.2-604.000',
    bpjsKesehatan: '000129381928',
    bpjsKetenagakerjaan: '2019283719',
    address: 'Jl. Raya Darmo No. 45',
    city: 'Surabaya',
    province: 'Jawa Timur',
    desa: 'Wonokromo',
    kecamatan: 'Wonokromo',
    kabupaten: 'Kota Surabaya',
    postalCode: '60241',
    phone: '081234567890',
    email: 'malik.ibrahim@mingda.co.id',
    emergencyContactName: 'Ahmad Dahlan',
    emergencyContactPhone: '081298765432',
    userId: 1,
    status: 'active',
    tanggalResign: null,
    tanggalMangkir: null,
    tanggalGagalProbation: null,
    tanggalPending: null,
    profilePhoto: 'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
    createdAt: '2023-01-15 08:00:00',
    updatedAt: '2026-09-28 08:00:00',
    shiftType: 'Normal (08:00 - 17:00)',
    profilePhotoUrl: 'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
    department: DepartmentModel(
      id: 1,
      name: 'Information Technology',
      description: 'Divisi Teknologi Informasi & Pengembangan Sistem',
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
    ),
    position: PositionModel(
      id: 1,
      code: 'SE',
      name: 'Software Engineer',
      level: '3',
      description: 'Pengembang Aplikasi Mobile',
      status: 'active',
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
      displayName: 'Software Engineer',
    ),
    workSchedule: WorkScheduleModel(
      id: 1,
      name: 'Shift Reguler (08:00 - 17:00)',
      startTime: '08:00:00',
      endTime: '17:00:00',
      lateTolerance: 15,
      overtimeThreshold: 60,
      isActive: true,
      createdAt: '2023-01-01',
      updatedAt: '2023-01-01',
    ),
  );

  @override
  Future<void> SignOutDataSource(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentProfile;
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentProfile = profile;
    return _currentProfile;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (currentPassword == 'wrongpassword') {
      throw const ValidationFailure('Password saat ini tidak sesuai');
    }
  }

  @override
  Future<AttendanceSummaryModel> getAttendanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AttendanceSummaryModel(
      total: 24,
      hadir: 20,
      terlambat: 2,
      izin: 1,
      sakit: 1,
      alpha: 0,
      cuti: 12,
      totalLateMinutes: 25,
    );
  }

  @override
  Future<AttendanceHistoryModel> getAttendanceHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AttendanceHistoryModel(
      currentPage: 1,
      data: dummyAttendanceItems,
      firstPageUrl: '1',
      from: 1,
      lastPage: 1,
      lastPageUrl: '1',
      links: const [
        AttendanceLinkModel(
          url: null,
          label: '&laquo; Previous',
          page: null,
          active: false,
        ),
        AttendanceLinkModel(url: '1', label: '1', page: 1, active: true),
        AttendanceLinkModel(
          url: null,
          label: 'Next &raquo;',
          page: null,
          active: false,
        ),
      ],
      nextPageUrl: null,
      path: '/mobile/v1/attendance/history',
      perPage: 15,
      prevPageUrl: null,
      to: dummyAttendanceItems.length,
      total: dummyAttendanceItems.length,
    );
  }

  static String _formatDateOnly(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Koleksi data dummy absensi untuk Dashboard & History Attendance yang selalu selaras dengan tanggal terkini
  static List<AttendanceItemModel> get dummyAttendanceItems {
    final now = DateTime.now();
    return [
      AttendanceItemModel(
        id: 1,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now),
        checkIn: '08:02',
        checkOut: '17:05',
        status: 'hadir',
        notes: 'Absensi tepat waktu di kantor',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 5.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 6.2,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 5,
        createdAt: '${_formatDateOnly(now)} 08:02:00',
        updatedAt: '${_formatDateOnly(now)} 17:05:00',
      ),
      AttendanceItemModel(
        id: 2,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 1))),
        checkIn: '08:20',
        checkOut: '17:00',
        status: 'terlambat',
        notes: 'Terlambat karena kendala lalu lintas',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 8.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 7.5,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 20,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 1)))} 08:20:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 1)))} 17:00:00',
      ),
      AttendanceItemModel(
        id: 3,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 2))),
        checkIn: '07:55',
        checkOut: '17:00',
        status: 'hadir',
        notes: 'Absensi tepat waktu',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 10.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 9.0,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 2)))} 07:55:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 2)))} 17:00:00',
      ),
      AttendanceItemModel(
        id: 4,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 3))),
        checkIn: null,
        checkOut: null,
        status: 'izin',
        notes: 'Izin keperluan keluarga mendesak',
        photoIn: null,
        photoOut: null,
        locationIn: null,
        gpsAccuracyIn: null,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: null,
        gpsAccuracyOut: null,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 3)))} 08:00:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 3)))} 08:00:00',
      ),
      AttendanceItemModel(
        id: 5,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 4))),
        checkIn: '07:50',
        checkOut: '17:15',
        status: 'hadir',
        notes: 'Hadir tepat waktu',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 6.5,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 7.0,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 15,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 4)))} 07:50:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 4)))} 17:15:00',
      ),
      AttendanceItemModel(
        id: 6,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 5))),
        checkIn: null,
        checkOut: null,
        status: 'sakit',
        notes: 'Sakit flu dengan surat dokter',
        photoIn: null,
        photoOut: null,
        locationIn: null,
        gpsAccuracyIn: null,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: null,
        gpsAccuracyOut: null,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 5)))} 08:00:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 5)))} 08:00:00',
      ),
      AttendanceItemModel(
        id: 7,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 6))),
        checkIn: '08:10',
        checkOut: '17:00',
        status: 'terlambat',
        notes: 'Terlambat 10 menit',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 7.2,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 8.1,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 10,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 6)))} 08:10:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 6)))} 17:00:00',
      ),
      AttendanceItemModel(
        id: 8,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 7))),
        checkIn: '07:45',
        checkOut: '17:00',
        status: 'hadir',
        notes: 'Hadir tepat waktu',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 6.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 6.0,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 7)))} 07:45:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 7)))} 17:00:00',
      ),
      AttendanceItemModel(
        id: 9,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 14))),
        checkIn: '08:00',
        checkOut: '17:00',
        status: 'hadir',
        notes: 'Hadir tepat waktu',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 7.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 7.0,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 14)))} 08:00:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 14)))} 17:00:00',
      ),
      AttendanceItemModel(
        id: 10,
        employeeId: 1,
        attendanceDate: _formatDateOnly(now.subtract(const Duration(days: 30))),
        checkIn: '07:55',
        checkOut: '17:00',
        status: 'hadir',
        notes: 'Hadir tepat waktu bulan lalu',
        photoIn: null,
        photoOut: null,
        locationIn: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyIn: 7.0,
        isMockedIn: false,
        gpsWarningsIn: null,
        isSuspiciousIn: false,
        locationOut: 'Kantor Pusat Mingda, Surabaya',
        gpsAccuracyOut: 7.0,
        isMockedOut: false,
        gpsWarningsOut: null,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 30)))} 07:55:00',
        updatedAt:
            '${_formatDateOnly(now.subtract(const Duration(days: 30)))} 17:00:00',
      ),
    ];
  }
}
