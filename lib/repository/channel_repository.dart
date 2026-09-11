import 'package:hive_ce/hive.dart';
import 'package:smsforward/models/channel/channel.dart';

class ChannelRepository {
  Future<List<Channel>> loadChannels() async {
    final box = await Hive.openBox<Channel>('channels');
    return box.values.toList();
  }

  Future<void> addChannel(Channel channel) async {
    final box = await Hive.openBox<Channel>('channels');
    await box.put(channel.id, channel);
  }

  Future<void> deleteChannel(String id) async {
    final box = await Hive.openBox<Channel>('channels');
    await box.delete(id);
  }
}