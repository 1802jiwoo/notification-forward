import 'package:smsforward/models/filter/keyword_match_target.dart';
import 'package:smsforward/models/installed_app.dart';

class Filter {
  final String id;
  final String name;
  final String? phoneNumber;
  final List<String> keywords;
  final KeywordMatchTarget keywordTarget;
  final String channelId;
  bool isActive;
  final List<InstalledApp> targetApps;

  Filter({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.keywords,
    required this.keywordTarget,
    required this.channelId,
    required this.isActive,
    required this.targetApps,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'keywords': keywords,
    'keywordTarget': keywordTarget.name,
    'channelId': channelId,
    'targetApps': targetApps.map((app) => app.packageName).toList(),
  };
}
