import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/models/installed_app.dart';
import 'package:smsforward/provider/filter_provider.dart';
import 'package:smsforward/widgets/app_icon.dart';
import 'package:smsforward/widgets/custom_switch.dart';

import '../../core/text_styles.dart';
import '../../widgets/back_icon_button.dart';

class DetailFilterScreen extends StatelessWidget {
  const DetailFilterScreen({super.key, required this.filter});

  final Filter filter;

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('필터 상세', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      filter.name,
                      style: textStyleW700(fontSize: 20),
                    ),
                  ),
                  CustomSwitch(
                    isActive: filter.isActive,
                    onChanged: (value) =>
                        filterProvider.toggleFilterActive(filter.id),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text('어떤 앱에서', style: textStyleW600(color: textTertiary)),
              const SizedBox(height: 10),
              filter.targetApps.isEmpty
                  ? const _AppChip(app: null)
                  : SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemCount: filter.targetApps.length,
                        itemBuilder: (context, index) =>
                            _AppChip(app: filter.targetApps[index]),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppChip extends StatelessWidget {
  const _AppChip({required this.app});

  final InstalledApp? app;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: background,
      ),
      child: app == null
          ? Text('모든 앱', style: textStyleW500())
          : Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(app: app),
                Text(app!.appName, style: textStyleW500()),
              ],
            ),
    );
  }
}
