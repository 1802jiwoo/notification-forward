import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/models/channel/channel_type.dart';
import 'package:smsforward/models/history/forward_log.dart';
import 'package:smsforward/models/installed_app.dart';
import 'package:smsforward/provider/forward_log_provider.dart';
import 'package:smsforward/provider/installed_apps_provider.dart';
import 'package:smsforward/widgets/channel/channel_type_ui.dart';
import 'package:smsforward/widgets/history/forward_log_ui.dart';

import '../../core/text_styles.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  List<MapEntry<String, List<ForwardLog>>> _groupByDate(
    List<ForwardLog> forwardLogs,
  ) {
    final today = DateTime.now();
    final Map<String, List<ForwardLog>> grouped = {};
    for (var forwardLog in forwardLogs) {
      grouped.putIfAbsent(forwardLog.dateLabel(today), () => []).add(forwardLog);
    }
    return grouped.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final forwardLogs = context.watch<ForwardLogProvider>().forwardLogs;
    final installedApps = context.watch<InstalledAppsProvider>().installedApps;
    final Map<String, InstalledApp> appsByPackageName = {
      for (var app in installedApps) app.packageName: app,
    };
    final groups = _groupByDate(forwardLogs);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text('기록', style: textStyleW700()),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: groups.length,
          itemBuilder: (context, index) => _ForwardLogGroup(
            label: groups[index].key,
            forwardLogs: groups[index].value,
            appsByPackageName: appsByPackageName,
          ),
        ),
      ),
    );
  }
}

class _ForwardLogGroup extends StatelessWidget {
  const _ForwardLogGroup({
    required this.label,
    required this.forwardLogs,
    required this.appsByPackageName,
  });

  final String label;
  final List<ForwardLog> forwardLogs;
  final Map<String, InstalledApp> appsByPackageName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '$label · ${forwardLogs.length}건',
            style: textStyleW600(fontSize: 14, color: textTertiary),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          separatorBuilder: (context, index) =>
              const Divider(color: line, height: 1),
          itemCount: forwardLogs.length,
          itemBuilder: (context, index) => _ForwardLogItem(
            forwardLog: forwardLogs[index],
            appIcon: appsByPackageName[forwardLogs[index].packageName]?.icon,
          ),
        ),
      ],
    );
  }
}

class _ForwardLogItem extends StatelessWidget {
  const _ForwardLogItem({required this.forwardLog, required this.appIcon});

  final ForwardLog forwardLog;
  final Uint8List? appIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appIcon == null ? background : null,
          image: appIcon == null
              ? null
              : DecorationImage(image: MemoryImage(appIcon!)),
        ),
      ),
      title: Text(forwardLog.title ?? '', style: textStyleW600(fontSize: 16)),
      subtitle: Text(
        '${forwardLog.filterName} · ${ChannelType.values.byName(forwardLog.channelType).title} · ${forwardLog.time}',
        style: textStyleW400(color: textTertiary, fontSize: 12),
      ),
    );
  }
}
