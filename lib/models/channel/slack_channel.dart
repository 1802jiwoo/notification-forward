import 'package:smsforward/models/channel/channel.dart';

class SlackChannel extends Channel {
  final String webhookUrl;

  SlackChannel({
    required super.id,
    required super.type,
    required super.name,
    required super.isActive,
    required this.webhookUrl,
  });

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'name': name,
    'webhookUrl': webhookUrl,
  };
}
