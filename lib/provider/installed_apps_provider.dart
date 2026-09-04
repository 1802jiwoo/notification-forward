import 'package:flutter/material.dart';
import 'package:smsforward/models/installed_app.dart';
import 'package:smsforward/repository/installed_apps_repository.dart';

class InstalledAppsProvider extends ChangeNotifier {
  final InstalledAppsRepository installedAppsRepository = InstalledAppsRepository();
  List<InstalledApp> _installedApps = [];

  List<InstalledApp> get installedApps => _installedApps;

  Future<void> loadInstalledApps() async {
    _installedApps = await installedAppsRepository.loadInstalledApps();
    notifyListeners();
  }
}
