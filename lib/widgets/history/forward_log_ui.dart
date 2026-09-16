import 'package:smsforward/models/history/forward_log.dart';

extension ForwardLogUi on ForwardLog {
  DateTime get sentAt => DateTime.fromMillisecondsSinceEpoch(timestamp);

  String get time {
    final sentAt = this.sentAt;
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(sentAt.hour)}:${twoDigits(sentAt.minute)}';
  }

  String dateLabel(DateTime today) {
    final sentAt = this.sentAt;
    if (sentAt.year == today.year &&
        sentAt.month == today.month &&
        sentAt.day == today.day) {
      return '오늘';
    }
    return '${sentAt.month}월 ${sentAt.day}일';
  }
}
