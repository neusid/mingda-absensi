import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/network/bloc/network_cubit.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/hive_constants.dart';
import 'package:mingda_app/core/storage/offline_queue_item.dart';
import 'package:mingda_app/core/storage/sync_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/dashboard_page.dart';

class FakeNetworkInfo implements NetworkInfo {
  bool _connected;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  FakeNetworkInfo({bool initialConnected = true}) : _connected = initialConnected;

  void setConnected(bool value) {
    _connected = value;
    _controller.add(value);
  }

  @override
  Future<bool> get isConnected async => _connected;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void dispose() {
    _controller.close();
  }
}

class FakeSyncManager implements SyncManager {
  final List<OfflineQueueItem> queue = [];
  final Map<String, QueueItemHandler> handlers = {};
  int syncCallCount = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> enqueue(OfflineQueueItem item) async {
    queue.add(item);
  }

  @override
  Future<List<OfflineQueueItem>> getPendingQueue() async {
    return List.from(queue);
  }

  @override
  Future<void> removeQueueItem(String id) async {
    queue.removeWhere((item) => item.id == id);
  }

  @override
  void registerHandler(String actionType, QueueItemHandler handler) {
    handlers[actionType] = handler;
  }

  @override
  Future<int> syncPendingQueue() async {
    syncCallCount++;
    int synced = 0;
    final items = List<OfflineQueueItem>.from(queue);
    for (final item in items) {
      final handler = handlers[item.actionType];
      if (handler != null) {
        final ok = await handler(item);
        if (ok) {
          queue.removeWhere((q) => q.id == item.id);
          synced++;
        }
      }
    }
    return synced;
  }

  @override
  ValueListenable<Box>? listenToQueue() => null;
}

class FakeDashboardBloc extends Cubit<DashboardState> implements DashboardBloc {
  FakeDashboardBloc(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
    overtimeThreshold: 60,
    isActive: true,
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  ),
);

const _testSummary = AttendanceSummaryEntity(
  total: 20,
  hadir: 18,
  terlambat: 1,
  izin: 1,
  sakit: 0,
  alpha: 0,
  cuti: 0,
  totalLateMinutes: 10,
);

const _testHistory = AttendanceHistoryEntity(
  currentPage: 1,
  data: [],
  firstPageUrl: '',
  from: 1,
  lastPage: 1,
  lastPageUrl: '',
  links: [],
  path: '',
  perPage: 10,
  to: 0,
  total: 0,
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null);
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('zh_CN', null);
  });

  group('Network & Offline Feature Tests', () {
    late FakeNetworkInfo fakeNetworkInfo;
    late FakeSyncManager fakeSyncManager;
    late NetworkCubit networkCubit;

    setUp(() {
      fakeNetworkInfo = FakeNetworkInfo(initialConnected: true);
      fakeSyncManager = FakeSyncManager();
      networkCubit = NetworkCubit(
        networkInfo: fakeNetworkInfo,
        syncManager: fakeSyncManager,
      );
    });

    tearDown(() {
      networkCubit.close();
      fakeNetworkInfo.dispose();
    });

    test('NetworkCubit emits offline state with message when connection lost', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      expect(networkCubit.state.isOnline, isTrue);

      // Trigger offline
      fakeNetworkInfo.setConnected(false);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(networkCubit.state.isOnline, isFalse);
      expect(networkCubit.state.hasTransitioned, isTrue);
      expect(networkCubit.state.message, contains('Mode offline aktif'));
    });

    test('NetworkCubit emits online and triggers auto-sync when connection restored', () async {
      // Setup initial offline
      fakeNetworkInfo.setConnected(false);
      await Future.delayed(const Duration(milliseconds: 50));
      expect(networkCubit.state.isOnline, isFalse);

      // Enqueue an item
      await fakeSyncManager.enqueue(OfflineQueueItem(
        id: 'leave_123',
        actionType: HiveConstants.actionSubmitLeave,
        payload: {'reason': 'Sakit'},
        createdAt: DateTime.now(),
      ));
      fakeSyncManager.registerHandler(HiveConstants.actionSubmitLeave, (item) async => true);

      // Trigger online
      fakeNetworkInfo.setConnected(true);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(networkCubit.state.isOnline, isTrue);
      expect(fakeSyncManager.syncCallCount, 1);
      expect(fakeSyncManager.queue, isEmpty);
      expect(networkCubit.state.syncedCount, 1);
    });

    test('OfflineQueueItem correctly serializes to and from Map', () {
      final now = DateTime.now();
      final item = OfflineQueueItem(
        id: 'q_001',
        actionType: HiveConstants.actionSubmitLeave,
        payload: {'leaveType': 'izin', 'reason': 'Urusan keluarga'},
        createdAt: now,
        retryCount: 2,
      );

      final map = item.toMap();
      final restored = OfflineQueueItem.fromMap(map);

      expect(restored.id, 'q_001');
      expect(restored.actionType, HiveConstants.actionSubmitLeave);
      expect(restored.payload['leaveType'], 'izin');
      expect(restored.retryCount, 2);
    });

    testWidgets('DashboardPage avatar dot is green when online and red when offline', (tester) async {
      final fakeBloc = FakeDashboardBloc(
        SuccessDashboardState(
          profileEntity: _testProfile,
          attendanceSummaryEntity: _testSummary,
          attendanceHistoryEntity: _testHistory,
        ),
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          builder: (context, _) => MultiBlocProvider(
            providers: [
              BlocProvider<DashboardBloc>.value(value: fakeBloc),
              BlocProvider<LanguageBloc>(
                create: (_) => LanguageBloc(),
              ),
              BlocProvider<NetworkCubit>.value(value: networkCubit),
            ],
            child: const MaterialApp(
              home: DashboardPage(),
            ),
          ),
        ),
      );

      // Settle initial page transition timer
      await tester.pump(const Duration(milliseconds: 400));

      // Check online dot
      expect(find.byKey(const Key('dashboard_avatar_online_dot')), findsOneWidget);
      final dotWidget = tester.widget<Container>(find.byKey(const Key('dashboard_avatar_online_dot')));
      final dec = dotWidget.decoration as BoxDecoration;
      expect(dec.color, const Color(0xFF00AA13)); // Green

      // Now set offline directly on NetworkCubit
      await networkCubit.onConnectivityChanged(false);
      await tester.pump();

      final dotOfflineWidget = tester.widget<Container>(find.byKey(const Key('dashboard_avatar_online_dot')));
      final decOffline = dotOfflineWidget.decoration as BoxDecoration;
      expect(decOffline.color, const Color(0xFFED2736)); // Red
    });
  });
}
