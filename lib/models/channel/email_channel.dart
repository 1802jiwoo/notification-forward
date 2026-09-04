import 'package:smsforward/models/channel/channel.dart';

class EmailChannel extends Channel {
  final String senderEmail;
  final String smtpHost;
  final String smtpPort;
  final String appPassword;
  final List<String> recipientEmails;

  EmailChannel({
    required super.id,
    required super.type,
    required super.name,
    required super.isActive,
    required this.senderEmail,
    required this.smtpHost,
    required this.smtpPort,
    required this.appPassword,
    required this.recipientEmails,
  });
}
