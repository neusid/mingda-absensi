import 'package:equatable/equatable.dart';

class NetworkState extends Equatable {
  final bool isOnline;
  final bool isSyncing;
  final bool hasTransitioned;
  final int syncedCount;
  final String? message;

  const NetworkState({
    this.isOnline = true,
    this.isSyncing = false,
    this.hasTransitioned = false,
    this.syncedCount = 0,
    this.message,
  });

  NetworkState copyWith({
    bool? isOnline,
    bool? isSyncing,
    bool? hasTransitioned,
    int? syncedCount,
    String? message,
  }) {
    return NetworkState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      hasTransitioned: hasTransitioned ?? this.hasTransitioned,
      syncedCount: syncedCount ?? this.syncedCount,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        isOnline,
        isSyncing,
        hasTransitioned,
        syncedCount,
        message,
      ];
}
