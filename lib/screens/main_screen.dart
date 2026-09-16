import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smsforward/models/bottom_item.dart';
import 'package:smsforward/screens/channel/channel_screen.dart';
import 'package:smsforward/screens/filter/filter_screen.dart';
import 'package:smsforward/screens/history/history_screen.dart';
import 'package:smsforward/screens/history/test_notification_screen.dart';

import '../core/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<BottomItem> _bottomItems = [
    const BottomItem(page: FilterScreen(), icon: Icons.tune, label: '필터'),
    const BottomItem(
      page: ChannelScreen(),
      icon: CupertinoIcons.paperplane,
      label: '채널',
    ),
    const BottomItem(page: HistoryScreen(), icon: Icons.history, label: '기록'),
    const BottomItem(page: TestNotificationScreen(), icon: Icons.settings_outlined, label: '설정'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            for (var bottomItem in _bottomItems) bottomItem.page,
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        bottomItems: _bottomItems,
        onTap: (value) => setState(() => _currentIndex = value),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.bottomItems,
    required this.onTap,
  });

  final int currentIndex;
  final List<BottomItem> bottomItems;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: primary,
      unselectedItemColor: textTertiary,
      backgroundColor: Colors.white,
      items: [
        for (var bottomItem in bottomItems)
          BottomNavigationBarItem(
            icon: Icon(bottomItem.icon),
            label: bottomItem.label,
          ),
      ],
    );
  }
}
