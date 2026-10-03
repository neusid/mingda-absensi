class OfflineQueueItem {
  final String id;
  final String actionType;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  const OfflineQueueItem({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'actionType': actionType,
        'payload': payload,
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory OfflineQueueItem.fromMap(Map<dynamic, dynamic> map) => OfflineQueueItem(
        id: map['id']?.toString() ?? '',
        actionType: map['actionType']?.toString() ?? '',
        payload: Map<String, dynamic>.from(map['payload'] as Map? ?? {}),
        createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
            DateTime.now(),
        retryCount: (map['retryCount'] as num?)?.toInt() ?? 0,
      );

  OfflineQueueItem copyWith({
    String? id,
    String? actionType,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
  }) =>
      OfflineQueueItem(
        id: id ?? this.id,
        actionType: actionType ?? this.actionType,
        payload: payload ?? this.payload,
        createdAt: createdAt ?? this.createdAt,
        retryCount: retryCount ?? this.retryCount,
      );
}
