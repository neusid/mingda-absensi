import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/network/bloc/network_state.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/sync_manager.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final NetworkInfo networkInfo;
  final SyncManager? syncManager;
  StreamSubscription<bool>? _connectivitySubscription;

  NetworkCubit({
    required this.networkInfo,
    this.syncManager,
  }) : super(const NetworkState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final isConnected = await networkInfo.isConnected;
      emit(state.copyWith(
        isOnline: isConnected,
        hasTransitioned: false,
      ));
    } catch (_) {
      emit(state.copyWith(isOnline: false, hasTransitioned: false));
    }

    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) => onConnectivityChanged(isConnected),
    );
  }

  Future<void> onConnectivityChanged(bool isConnected) async {
    if (state.isOnline == isConnected) return;

    if (!isConnected) {
      emit(state.copyWith(
        isOnline: false,
        hasTransitioned: true,
        isSyncing: false,
        message: 'Koneksi terputus. Mode offline aktif.',
      ));
    } else {
      emit(state.copyWith(
        isOnline: true,
        hasTransitioned: true,
        isSyncing: true,
        message: 'Kembali online. Menyinkronkan data...',
      ));

      int syncedCount = 0;
      if (syncManager != null) {
        syncedCount = await syncManager!.syncPendingQueue();
      }

      emit(state.copyWith(
        isSyncing: false,
        syncedCount: syncedCount,
        message: syncedCount > 0
            ? 'Sinkronisasi selesai: $syncedCount data tersinkronisasi.'
            : null,
      ));
    }
  }

  Future<void> refreshConnectivity() async {
    final isConnected = await networkInfo.isConnected;
    await onConnectivityChanged(isConnected);
  }

  void clearMessage() {
    emit(state.copyWith(message: null));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
