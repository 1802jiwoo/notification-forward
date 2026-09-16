import 'package:smsforward/core/app_channel.dart';
import 'package:smsforward/models/history/forward_log.dart';

class ForwardLogRepository {
  Future<List<ForwardLog>> loadForwardLogs() async {
    final data = await AppChannel.instance.invokeMethod('getForwardLogs');
    return data.map<ForwardLog>((e) => ForwardLog.fromMap(e)).toList();
  }

  Future<bool> retryForwardLog(int id) async {
    final success = await AppChannel.instance.invokeMethod('retryForward', {
      'id': id,
    });
    return success as bool;
  }
}
