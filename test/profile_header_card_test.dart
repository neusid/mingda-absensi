import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_header_card.dart';

Widget _buildTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

const _testProfile = ProfileEntity(
  id: 1,
  employeeCode: 'MD-2024-001',
  nik: '3578012345670001',
  name: 'Livia Vacarro',
  gender: 'Perempuan',
  birthPlace: 'Surabaya',
  birthDate: '2000-01-01',
  maritalStatus: 'Belum Menikah',
  agama: 'Islam',
  bangsa: 'Indonesia',
  statusKependudukan: 'WNI',
  tanggunganAnak: 0,
  namaIbuKandung: 'Ibu',
  ktp: '3578012345670001',
  kartuKeluarga: '3578012345670002',
  departmentId: 1,
  subDepartmentId: 1,
  positionId: 1,
  joinDate: '2023-01-01',
  employmentStatus: 'Karyawan Tetap',
  serikat: 'Tidak',
  lulusanSekolah: 'S1',
  workScheduleId: 1,
  bank: 'BCA',
  nomorRekening: '1234567890',
  taxNpwp: '12.345.678.9-000.000',
  bpjsKesehatan: '00000000000',
  bpjsKetenagakerjaan: '00000000000',
  address: 'Kantor Mingda',
  city: 'Surabaya',
  province: 'Jawa Timur',
  desa: '-',
  kecamatan: '-',
  kabupaten: 'Surabaya',
  postalCode: '60000',
  phone: '08123456789',
  email: 'karyawan@email.com',
  emergencyContactName: '-',
  emergencyContactPhone: '-',
  userId: 1,
  status: 'active',
  profilePhoto: 'assets/img/mingda_logo.png',
  createdAt: '2023-01-01',
  updatedAt: '2023-01-01',
  shiftType: 'Normal',
  profilePhotoUrl: '',
  department: DepartmentEntity(
    id: 1,
    name: 'General',
    description: '-',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
  position: PositionEntity(
    id: 1,
    code: 'STF',
    name: 'Staff',
    description: '-',
    status: 'active',
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
    displayName: 'Staff',
  ),
  workSchedule: WorkScheduleEntity(
    id: 1,
    name: 'Reguler',
    startTime: '08:00',
    endTime: '17:00',
    lateTolerance: 15,
    overtimeThreshold: 30,
    isActive: true,
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
);

void main() {
  group('ProfileHeaderCard (profile_header_card_remake.svg spec)', () {
    testWidgets('renders greeting, name, email badge, monogram LV, and notif button', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _buildTestableWidget(
          ProfileHeaderCard(
            profile: _testProfile,
            onNotificationTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Micro Greeting
      expect(find.text('Selamat Datang 👋'), findsOneWidget);

      // Name
      expect(find.text('Livia Vacarro'), findsOneWidget);

      // Status Capsule Badge Email
      expect(find.text('karyawan@email.com'), findsOneWidget);
      expect(find.byIcon(Icons.mail_outline_rounded), findsOneWidget);

      // Monogram initials LV from "Livia Vacarro"
      expect(find.text('LV'), findsOneWidget);

      // Notification Button & tap
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('generates initials MA for Muhammad Ali', (tester) async {
      final aliProfile = ProfileEntity(
        id: 2,
        employeeCode: 'MD-2024-002',
        nik: '3578012345670002',
        name: 'Muhammad Ali',
        gender: 'Laki-laki',
        birthPlace: 'Surabaya',
        birthDate: '1995-05-05',
        maritalStatus: 'Menikah',
        agama: 'Islam',
        bangsa: 'Indonesia',
        statusKependudukan: 'WNI',
        tanggunganAnak: 1,
        namaIbuKandung: 'Ibu',
        ktp: '3578012345670002',
        kartuKeluarga: '3578012345670003',
        departmentId: 1,
        subDepartmentId: 1,
        positionId: 1,
        joinDate: '2022-01-01',
        employmentStatus: 'Karyawan Tetap',
        serikat: 'Tidak',
        lulusanSekolah: 'S1',
        workScheduleId: 1,
        bank: 'BCA',
        nomorRekening: '9876543210',
        taxNpwp: '12.345.678.9-000.000',
        bpjsKesehatan: '00000000000',
        bpjsKetenagakerjaan: '00000000000',
        address: 'Kantor Mingda',
        city: 'Surabaya',
        province: 'Jawa Timur',
        desa: '-',
        kecamatan: '-',
        kabupaten: 'Surabaya',
        postalCode: '60000',
        phone: '081298765432',
        email: 'muhammad.ali@mingda.co.id',
        emergencyContactName: '-',
        emergencyContactPhone: '-',
        userId: 2,
        status: 'active',
        profilePhoto: 'assets/img/mingda_logo.png',
        createdAt: '2022-01-01',
        updatedAt: '2022-01-01',
        shiftType: 'Normal',
        profilePhotoUrl: '',
        department: _testProfile.department,
        position: _testProfile.position,
        workSchedule: _testProfile.workSchedule,
      );

      await tester.pumpWidget(
        _buildTestableWidget(
          ProfileHeaderCard(profile: aliProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Monogram initials MA from "Muhammad Ali"
      expect(find.text('MA'), findsOneWidget);
    });
  });
}
