import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/models/installed_app.dart';
import 'package:smsforward/provider/installed_apps_provider.dart';
import 'package:smsforward/widgets/app_icon.dart';
import 'package:smsforward/widgets/back_icon_button.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../widgets/custom_long_text_button.dart';

class SelectTargetAppScreen extends StatefulWidget {
  const SelectTargetAppScreen({super.key, required this.targetApps});

  final List<InstalledApp> targetApps;

  @override
  State<SelectTargetAppScreen> createState() => _SelectTargetAppScreenState();
}

class _SelectTargetAppScreenState extends State<SelectTargetAppScreen> {
  late final List<InstalledApp> targetApps;

  @override
  void initState() {
    super.initState();
    targetApps = [...widget.targetApps];
  }

  @override
  Widget build(BuildContext context) {
    final List<InstalledApp> installedApps = context
        .watch<InstalledAppsProvider>()
        .installedApps;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('대상 앱', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        actions: [
          Text(
            '${targetApps.isEmpty ? 1 : targetApps.length}개 선택',
            style: textStyleW700(color: primary),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned.fill(
                child: RefreshIndicator(
                  color: primary,
                  onRefresh: () async {
                    await context
                        .read<InstalledAppsProvider>()
                        .loadInstalledApps();
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 130),
                    children: [
                      AppItem(
                        app: null,
                        selected: targetApps.isEmpty,
                        onToggle: () {
                          setState(() {
                            targetApps.clear();
                          });
                        },
                      ),
                      for (var app in installedApps)
                        AppItem(
                          app: app,
                          selected: targetApps.contains(app),
                          onToggle: () {
                            setState(() {
                              if (targetApps.contains(app)) {
                                targetApps.remove(app);
                              } else {
                                targetApps.add(app);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomLongTextButton(
                  title: '선택 완료',
                  callback: () => Navigator.pop(context, targetApps),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppItem extends StatelessWidget {
  const AppItem({
    super.key,
    this.app,
    required this.selected,
    required this.onToggle,
  });

  final InstalledApp? app;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        spacing: 15,
        children: [
          Checkbox(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: selected,
            activeColor: primary,
            side: const BorderSide(color: line2, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (_) => onToggle(),
          ),
          AppIcon(app: app, size: 40),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app?.appName ?? '모든 앱', style: textStyleW600(fontSize: 16)),
                Text(
                  app?.packageName ?? '기기에 오는 모든 알림',
                  style: textStyleW400(color: textTertiary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
