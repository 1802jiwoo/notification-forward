import 'package:smsforward/models/channel/channel.dart';

class SmsChannel extends Channel {
  final String recipientPhoneNumber;

  SmsChannel({
    required super.id,
    required super.type,
    required super.name,
    required super.isActive,
    required this.recipientPhoneNumber,
  });
}
