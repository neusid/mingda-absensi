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
import 'package:mingda_app/features/dashboard/domain/usecases/change_password_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_summary_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/change_password_page.dart';

class MockDashboardRepository implements DashboardRepository {
  String? lastCurrentPassword;
  String? lastNewPassword;
  String? lastConfirmPassword;
  Failure? failureToReturn;

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
    lastConfirmPassword = confirmPassword;
    if (failureToReturn != null) {
      return Left(failureToReturn!);
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, ProfileEntity>> getDataProfile() async =>
      const Right(_dummyProfile);

  @override
  Future<Either<Failure, AttendanceSummaryEntity>>
      getDataAttendanceSummary() async => const Right(AttendanceSummaryEntity(
            total: 20,
            hadir: 18,
            terlambat: 1,
            izin: 1,
            sakit: 0,
            alpha: 0,
            cuti: 0,
            totalLateMinutes: 15,
          ));

  @override
  Future<Either<Failure, AttendanceHistoryEntity>>
      getDataAttendanceHistory() async => const Right(AttendanceHistoryEntity(
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
          ));

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
          ProfileEntity profile) async =>
      Right(profile);

  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);
}

const _dummyProfile = ProfileEntity(
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
  department: DepartmentEntity(
    id: 1,
    name: 'IT',
    description: 'Divisi IT',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
  position: PositionEntity(
    id: 1,
    code: 'SE',
    name: 'Software Engineer',
    level: '3',
    description: 'Mobile Developer',
    status: 'active',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
    displayName: 'Software Engineer',
  ),
  workSchedule: WorkScheduleEntity(
    id: 1,
    name: 'Shift Reguler',
    startTime: '08:00:00',
    endTime: '17:00:00',
    lateTolerance: 15,
    overtimeThreshold: 60,
    isActive: true,
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
);

Widget _buildTestableWidget({
  required DashboardBloc bloc,
}) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, child) {
      return MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: bloc,
              child: const ChangePasswordPage(),
            ),
          ),
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      changePasswordUsecase:
          ChangePasswordUsecase(dashboardRepository: mockRepo),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ChangePasswordPage UI & Mingda Gradient Design Pattern Tests', () {
    testWidgets('Renders all Mingda Gradient hero, form, checklist and button',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      // AppBar title
      expect(find.text('Ubah Kata Sandi'), findsOneWidget);

      // Mingda Gradient Hero Card
      expect(find.text('Keamanan Kata Sandi'), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset_rounded), findsOneWidget);

      // Clean Solid Surface Form Card
      expect(find.text('Formulir Kata Sandi'), findsOneWidget);
      expect(find.byKey(const Key('current_password_input')), findsOneWidget);
      expect(find.byKey(const Key('new_password_input')), findsOneWidget);
      expect(find.byKey(const Key('confirm_password_input')), findsOneWidget);

      // Criteria Checklist
      expect(find.text('Kriteria Keamanan Kata Sandi:'), findsOneWidget);
      expect(find.text('Minimal 8 karakter'), findsOneWidget);
      expect(find.text('Berbeda dari kata sandi saat ini'), findsOneWidget);
      expect(find.text('Konfirmasi kata sandi sesuai'), findsOneWidget);

      // Sticky Bottom Submit Button
      expect(find.byKey(const Key('submit_change_password_button')),
          findsOneWidget);
      expect(find.text('Simpan Kata Sandi Baru'), findsOneWidget);
    });

    testWidgets('Toggles obscure text visibility on password fields',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      // Find visibility toggle icon buttons
      final toggleButtons = find.byType(IconButton);
      expect(toggleButtons, findsNWidgets(4)); // 1 back button + 3 visibility toggles

      // Tap first visibility toggle
      await tester.tap(toggleButtons.at(1));
      await tester.pumpAndSettle();

      // Icon should have toggled to visibility_rounded
      expect(find.byIcon(Icons.visibility_rounded), findsWidgets);
    });

    testWidgets('Shows validation errors when form is submitted empty',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      // Scroll to submit button and tap
      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      // Form validation error texts
      expect(find.text('Kata sandi saat ini wajib diisi'), findsOneWidget);
      expect(find.text('Kata sandi baru wajib diisi'), findsOneWidget);
      expect(find.text('Konfirmasi kata sandi wajib diisi'), findsOneWidget);
    });

    testWidgets('Validates new password length less than 8 characters',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('current_password_input')), 'oldPassword123');
      await tester.enterText(
          find.byKey(const Key('new_password_input')), 'short');
      await tester.enterText(
          find.byKey(const Key('confirm_password_input')), 'short');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Kata sandi baru minimal 8 karakter'), findsOneWidget);
    });

    testWidgets(
        'Validates that new password cannot be the same as current password',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('current_password_input')), 'samePassword123');
      await tester.enterText(
          find.byKey(const Key('new_password_input')), 'samePassword123');
      await tester.enterText(
          find.byKey(const Key('confirm_password_input')), 'samePassword123');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(
          find.text(
              'Kata sandi baru tidak boleh sama dengan kata sandi saat ini'),
          findsOneWidget);
    });

    testWidgets('Validates confirmation password mismatch', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('current_password_input')), 'oldPassword123');
      await tester.enterText(
          find.byKey(const Key('new_password_input')), 'newPassword456');
      await tester.enterText(
          find.byKey(const Key('confirm_password_input')), 'mismatchPassword789');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(
          find.text('Konfirmasi kata sandi tidak cocok dengan kata sandi baru'),
          findsOneWidget);
    });

    testWidgets('Successfully submits change password with valid input',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('current_password_input')), 'oldPassword123');
      await tester.enterText(
          find.byKey(const Key('new_password_input')), 'newPassword456');
      await tester.enterText(
          find.byKey(const Key('confirm_password_input')), 'newPassword456');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));

      // Repository received the exact parameters
      expect(mockRepo.lastCurrentPassword, 'oldPassword123');
      expect(mockRepo.lastNewPassword, 'newPassword456');
      expect(mockRepo.lastConfirmPassword, 'newPassword456');
    });

    testWidgets('Handles error message when repository returns failure',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      mockRepo.failureToReturn =
          const ValidationFailure('Password saat ini tidak sesuai');

      await tester.pumpWidget(_buildTestableWidget(bloc: bloc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('current_password_input')), 'wrongPassword123');
      await tester.enterText(
          find.byKey(const Key('new_password_input')), 'newPassword456');
      await tester.enterText(
          find.byKey(const Key('confirm_password_input')), 'newPassword456');
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('submit_change_password_button'));
      await tester.tap(submitBtn);
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));

      expect(mockRepo.lastCurrentPassword, 'wrongPassword123');
    });
  });
}
