import 'package:smsforward/models/channel/channel_type.dart';

abstract class Channel {
  final String id;
  final ChannelType type;
  final String name;
  final bool isActive;

  Channel({
    required this.id,
    required this.type,
    required this.name,
    required this.isActive,
  });

  Map<String, dynamic> toMap();
}
