import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/core/app_channel.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/hive/hive_registrar.g.dart';
import 'package:smsforward/provider/channel_provider.dart';
import 'package:smsforward/provider/filter_provider.dart';
import 'package:smsforward/provider/forward_log_provider.dart';
import 'package:smsforward/provider/installed_apps_provider.dart';
import 'package:smsforward/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapters();

  await AppChannel.instance.invokeMethod("notificationAccessSettings");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChannelProvider()..loadChannels(),
        ),
        ChangeNotifierProvider(
          create: (context) => InstalledAppsProvider()..loadInstalledApps(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterProvider()..loadFilters(),
        ),
        ChangeNotifierProvider(
          create: (context) => ForwardLogProvider()..loadForwardLogs(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: primary,
            backgroundColor: Colors.white,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: primary,
            selectionColor: primaryContainer,
            selectionHandleColor: primary
          )
        ),
        home: const MainScreen(),
      ),
    ),
  );
}
