import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:smsforward/core/app_channel.dart';
import 'package:smsforward/models/history/forward_log.dart';
import 'package:smsforward/repository/forward_log_repository.dart';

class ForwardLogProvider extends ChangeNotifier {
  final ForwardLogRepository forwardLogRepository = ForwardLogRepository();
  List<ForwardLog> _forwardLogs = [];

  List<ForwardLog> get forwardLogs => _forwardLogs;

  ForwardLogProvider() {
    AppChannel.instance.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onForwardLogInserted') {
      await loadForwardLogs();
    }
  }

  Future<void> loadForwardLogs() async {
    _forwardLogs = await forwardLogRepository.loadForwardLogs();
    notifyListeners();
  }

  @override
  void dispose() {
    AppChannel.instance.setMethodCallHandler(null);
    super.dispose();
  }
}
