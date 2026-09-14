import 'package:smsforward/models/channel/channel.dart';

class DiscordChannel extends Channel {
  final String webhookUrl;

  DiscordChannel({
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
