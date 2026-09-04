import 'package:smsforward/core/app_channel.dart';
import 'package:smsforward/models/installed_app.dart';

class InstalledAppsRepository {
  Future<List<InstalledApp>> loadInstalledApps() async {
    final data = await AppChannel.instance.invokeMethod('loadInstalledApps');
    return data.map<InstalledApp>((e) => InstalledApp.fromMap(e)).toList();
  }
}
