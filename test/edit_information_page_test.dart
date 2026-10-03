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

class MockDashboardRepository implements DashboardRepository {
  ProfileEntity? profileToReturn;
  Failure? failureToReturn;
  ProfileEntity? updatedProfileReceived;

  @override
  Future<Either<Failure, ProfileEntity>> getDataProfile() async {
    if (failureToReturn != null) return Left(failureToReturn!);
    return Right(profileToReturn ?? _testProfile);
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    updatedProfileReceived = profile;
    if (failureToReturn != null) return Left(failureToReturn!);
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

Widget _buildTestablePage({
  required DashboardBloc bloc,
  required ProfileEntity profile,
}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: EditInformationPage(profile: profile),
          ),
        ),
      ),
    ),
  );
}

void main() {
  late MockDashboardRepository mockRepo;
  late DashboardBloc bloc;

  setUp(() {
    mockRepo = MockDashboardRepository();
    bloc = DashboardBloc(
      signoutUsecase: SignoutUsecase(dashboardRepository: mockRepo),
      getprofileUsecase: GetProfileUsecase(dashboardRepository: mockRepo),
      getattendanceSummaryUsecase:
          GetAttendanceSummaryUsecase(dashboardRepository: mockRepo),
      getAttendanceHistoryUsecase:
          GetAttendanceHistoryUsecase(dashboardRepository: mockRepo),
      updateProfileUsecase: UpdateProfileUsecase(dashboardRepository: mockRepo),
    );
  });

  group('UpdateProfileUsecase Tests', () {
    test('successfully calls repository to update profile', () async {
      final usecase = UpdateProfileUsecase(dashboardRepository: mockRepo);
      final updated = _testProfile.copyWith(name: 'Budi Santoso');

      final result = await usecase(updated);

      expect(result, isA<Right<Failure, ProfileEntity>>());
      expect(mockRepo.updatedProfileReceived?.name, 'Budi Santoso');
    });

    test('returns failure when repository fails', () async {
      mockRepo.failureToReturn = const ServerFailure('Server error');
      final usecase = UpdateProfileUsecase(dashboardRepository: mockRepo);

      final result = await usecase(_testProfile);

      expect(result, isA<Left<Failure, ProfileEntity>>());
    });
  });

  group('EditInformationPage Widget Tests', () {
    testWidgets('renders all section headers, initial data, and action button',
        (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      // Title AppBar
      expect(find.text('Ubah Informasi'), findsOneWidget);

      // Avatar Card
      expect(find.text('Karyawan Aktif'), findsOneWidget);
      expect(find.text('MD-2024-001'), findsWidgets);
      expect(find.text('MI'), findsOneWidget);

      // Notice HRD
      expect(
          find.textContaining('Data kepegawaian (Kode, Departemen, Jabatan, Shift) dikunci'),
          findsOneWidget);

      // Section Titles
      expect(find.text('Informasi Karyawan'), findsOneWidget);
      expect(find.text('Data Kepegawaian (Terkunci)'), findsOneWidget);

      // Prefilled values
      expect(find.text('Malik Ibrahim'), findsWidgets);
      expect(find.text('081234567890'), findsOneWidget);
      expect(find.text('malik.ibrahim@mingda.co.id'), findsOneWidget);

      // Read-only tiles
      expect(find.text('Information Technology'), findsWidgets);
      expect(find.text('Software Engineer'), findsWidgets);
      expect(find.text('Normal (08:00 - 17:00)'), findsOneWidget);

      // Sticky Save Button
      expect(find.text('Simpan Perubahan'), findsOneWidget);
    });

    testWidgets('shows validation error when name is empty', (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      // Clear the name field
      final nameField = find.widgetWithText(TextFormField, 'Malik Ibrahim');
      await tester.enterText(nameField, '');
      await tester.pumpAndSettle();

      // Tap Simpan Perubahan
      final saveBtn = find.text('Simpan Perubahan');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    });

    testWidgets('shows validation error when email is invalid', (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      // Enter invalid email
      final emailField =
          find.widgetWithText(TextFormField, 'malik.ibrahim@mingda.co.id');
      await tester.enterText(emailField, 'emailtanpaat');
      await tester.pumpAndSettle();

      // Tap Simpan Perubahan
      final saveBtn = find.text('Simpan Perubahan');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Format email tidak valid'), findsOneWidget);
    });

    testWidgets('shows validation error when phone number is invalid',
        (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      // Enter short phone
      final phoneField =
          find.widgetWithText(TextFormField, '081234567890');
      await tester.enterText(phoneField, '123');
      await tester.pumpAndSettle();

      // Tap Simpan Perubahan
      final saveBtn = find.text('Simpan Perubahan');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(find.text('Nomor telepon tidak valid'), findsOneWidget);
    });

    testWidgets('tapping camera badge opens Ubah Foto Profil bottom sheet',
        (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      final cameraIcon = find.byIcon(Icons.camera_alt_rounded);
      expect(cameraIcon, findsOneWidget);

      await tester.tap(cameraIcon);
      await tester.pumpAndSettle();

      expect(find.text('Ubah Foto Profil'), findsOneWidget);
      expect(find.text('Ambil Foto dari Kamera'), findsOneWidget);
      expect(find.text('Pilih dari Galeri'), findsOneWidget);
      expect(find.text('Gunakan Inisial Avatar'), findsOneWidget);

      // Tap Ambil Foto dari Kamera
      await tester.tap(find.text('Ambil Foto dari Kamera'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Bottom sheet closed
      expect(find.text('Ubah Foto Profil'), findsNothing);
    });

    testWidgets('submitting valid form triggers update in bloc',
        (tester) async {
      await tester.pumpWidget(
        _buildTestablePage(bloc: bloc, profile: _testProfile),
      );
      await tester.pumpAndSettle();

      // Enter new name
      final nameField = find.widgetWithText(TextFormField, 'Malik Ibrahim');
      await tester.enterText(nameField, 'Malik Ibrahim S.Kom');
      await tester.pumpAndSettle();

      // Tap Simpan Perubahan
      final saveBtn = find.text('Simpan Perubahan');
      await tester.tap(saveBtn);
      await tester.pump();

      // Should show Menyimpan... while in progress
      expect(find.text('Menyimpan...'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));

      // Verified mock received the updated name
      expect(mockRepo.updatedProfileReceived?.name, 'Malik Ibrahim S.Kom');
    });
  });
}
