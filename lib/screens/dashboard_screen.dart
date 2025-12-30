import 'package:flutter/material.dart';

import '../services/fcm_service.dart';
import 'evac_map_screen.dart';
import 'report/report_list_screen.dart';
import 'news/news_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _fcmInitialized = false;

  final List<Widget> _pages = const [
    EvacMapScreen(),
    ReportListScreen(),
    NewsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_fcmInitialized) {
      FCMService.init(context);
      _fcmInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Evac Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined),
            label: "Laporan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: "Berita",
          ),
        ],
      ),
    );
  }
}
