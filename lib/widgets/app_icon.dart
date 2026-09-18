import 'package:flutter/material.dart';
import 'package:smsforward/models/installed_app.dart';

import '../core/colors.dart';

/// Rounded app icon. Shows [app]'s icon, or a placeholder tile when
/// [app] is null (used to represent "all apps").
class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.app, this.size = 30});

  final InstalledApp? app;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: app == null ? primaryContainer : null,
        image: app == null
            ? null
            : DecorationImage(image: MemoryImage(app!.icon)),
      ),
    );
  }
}