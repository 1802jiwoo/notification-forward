import 'package:flutter/cupertino.dart';
import 'package:smsforward/models/history/forward_log.dart';
import 'package:smsforward/repository/forward_log_repository.dart';

class ForwardLogProvider extends ChangeNotifier {
  final ForwardLogRepository forwardLogRepository = ForwardLogRepository();
  List<ForwardLog> _forwardLogs = [];

  List<ForwardLog> get forwardLogs => _forwardLogs;

  Future<void> loadForwardLogs() async {
    _forwardLogs = await forwardLogRepository.loadForwardLogs();
    notifyListeners();
  }
}
