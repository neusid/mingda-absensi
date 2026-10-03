import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_summary_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/edit_information_page.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/profile_page.dart';

class MockDashboardRepo implements DashboardRepository {
  @override
  Future<Either<Failure, ProfileEntity>> getDataProfile() async {
    return const Right(_testProfile);
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    return Right(profile);
  }

  @override
  Future<Either<Failure, AttendanceSummaryEntity>>
      getDataAttendanceSummary() async {
    return const Right(
      AttendanceSummaryEntity(
        total: 20,
        hadir: 18,
        terlambat: 1,
        izin: 1,
        sakit: 0,
        alpha: 0,
        cuti: 0,
        totalLateMinutes: 15,
      ),
    );
  }

  @override
  Future<Either<Failure, AttendanceHistoryEntity>>
      getDataAttendanceHistory() async {
    return const Right(
      AttendanceHistoryEntity(
        currentPage: 1,
        data: [],
        firstPageUrl: '',
        from: 1,
        lastPage: 1,
        lastPageUrl: '',
        links: [],
        path: '',
        perPage: 10,
        to: 1,
        total: 0,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return const Right(null);
  }
}

const _testProfile = ProfileEntity(
  id: 1,
  employeeCode: 'MD-2024-001',
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
  positionId: 1,
  joinDate: '2023-01-15',
  employmentStatus: 'Karyawan Tetap',
  serikat: 'Tidak',
  lulusanSekolah: 'S1 Teknik Informatika',
  workScheduleId: 1,
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
  profilePhoto: 'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
  createdAt: '2023-01-15',
  updatedAt: '2026-09-28',
  shiftType: 'Normal (08:00 - 17:00)',
  profilePhotoUrl: 'assets/img/SXjGsFTmyKziA5U3bkxY85nZ53l4ld.jpg',
  department: DepartmentEntity(
    id: 1,
    name: 'Information Technology',
    description: 'Divisi TI',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
  position: PositionEntity(
    id: 1,
    code: 'SE',
    name: 'Software Engineer',
    displayName: 'Software Engineer',
    description: 'Mobile Dev',
    status: 'active',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
  workSchedule: WorkScheduleEntity(
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

void main() {
  testWidgets('tapping Ubah Informasi in ProfilePage navigates to EditInformationPage',
      (tester) async {
    final mockRepo = MockDashboardRepo();
    final bloc = DashboardBloc(
      signoutUsecase: SignoutUsecase(dashboardRepository: mockRepo),
      getprofileUsecase: GetProfileUsecase(dashboardRepository: mockRepo),
      getattendanceSummaryUsecase:
          GetAttendanceSummaryUsecase(dashboardRepository: mockRepo),
      getAttendanceHistoryUsecase:
          GetAttendanceHistoryUsecase(dashboardRepository: mockRepo),
      updateProfileUsecase: UpdateProfileUsecase(dashboardRepository: mockRepo),
    );

    // Seed state directly into bloc
    bloc.emit(
      SuccessDashboardState(
        profileEntity: _testProfile,
        attendanceSummaryEntity: AttendanceSummaryEntity(
          total: 20,
          hadir: 18,
          terlambat: 1,
          izin: 1,
          sakit: 0,
          alpha: 0,
          cuti: 0,
          totalLateMinutes: 15,
        ),
        attendanceHistoryEntity: AttendanceHistoryEntity(
          currentPage: 1,
          data: [],
          firstPageUrl: '',
          from: 1,
          lastPage: 1,
          lastPageUrl: '',
          links: [],
          path: '',
          perPage: 10,
          to: 1,
          total: 0,
        ),
      ),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, _) => MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const ProfilePage(),
          ),
        ),
      ),
    );

    // Wait for page transition delay
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    final ubahInfoBtn = find.text('Ubah Informasi');
    expect(ubahInfoBtn, findsOneWidget);

    await tester.ensureVisible(ubahInfoBtn);
    await tester.tap(ubahInfoBtn);
    await tester.pumpAndSettle();

    // Verify EditInformationPage is now shown on the screen
    expect(find.byType(EditInformationPage), findsOneWidget);
    expect(find.text('Informasi Karyawan'), findsOneWidget);
  });
}
