class ForwardLog {
  final int id;
  final String packageName;
  final int timestamp;
  final String? title;
  final String filterName;
  final String channelType;
  final bool success;

  ForwardLog({
    required this.id,
    required this.packageName,
    required this.timestamp,
    required this.title,
    required this.filterName,
    required this.channelType,
    required this.success,
  });

  factory ForwardLog.fromMap(Map<Object?, Object?> map) => ForwardLog(
    id: map['id'] as int,
    packageName: map['packageName'].toString(),
    timestamp: map['timestamp'] as int,
    title: map['title']?.toString(),
    filterName: map['filterName'].toString(),
    channelType: map['channelType'].toString(),
    success: map['success'] as bool,
  );
}
