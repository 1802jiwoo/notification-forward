import 'package:smsforward/models/filter/keyword_match_target.dart';
import 'package:smsforward/models/installed_app.dart';

class Filter {
  final String id;
  final String name;
  final String? phoneNumber;
  final List<String> keywords;
  final KeywordMatchTarget keywordTarget;
  final List<String> channelIds;
  final bool isActive;
  final List<InstalledApp> targetApps;

  Filter({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.keywords,
    required this.keywordTarget,
    required this.channelIds,
    required this.isActive,
    required this.targetApps,
  });
}
