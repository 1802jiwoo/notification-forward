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
  final PageController _pageController = PageController();
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

  int get currentIndex =>
      _pageController.hasClients ? _pageController.page!.round() : 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) => setState(() {}),
          children: List.generate(
            _bottomItems.length,
            (index) => _bottomItems[index].page,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        bottomItems: _bottomItems,
        onTap: (value) async {
          await _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
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
