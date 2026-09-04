import 'package:flutter/cupertino.dart';
import 'package:smsforward/models/channel/channel.dart';
import 'package:smsforward/repository/channel_repository.dart';

class ChannelProvider extends ChangeNotifier {
  final ChannelRepository channelRepository = ChannelRepository();
  List<Channel> _channels = [];

  List<Channel> get channels => _channels;

  Future<void> loadChannels() async {
    _channels = await channelRepository.loadChannels();
    notifyListeners();
  }

  Future<void> addChannel(Channel channel) async {
    await channelRepository.addChannel(channel);
    await loadChannels();
  }
}