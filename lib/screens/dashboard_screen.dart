import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/fcm_service.dart';

import 'login_screen.dart';
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

  static const Color mainRed = Color(0xFFD73535);
  static const Color reportBlue = Color(0xFF4988C4);
  static const Color newsOrange = Color(0xFFFFA240); 

  final List<Widget> _pages = const [
    EvacMapScreen(),
    ReportListScreen(),
    NewsScreen(),
  ];

  final List<String> _pageTitles = const [
    "Evac Map",
    "Laporan Kondisi",
    "Berita Gempa",
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
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _currentIndex == 1
            ? reportBlue
            : _currentIndex == 2
                ? newsOrange 
                : mainRed,

        toolbarHeight: 72,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),

        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: "Logout",
            onPressed: () => _confirmLogout(context, auth),
          ),
        ],
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },

        selectedItemColor: mainRed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),

        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),

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

  void _confirmLogout(BuildContext context, AuthProvider auth) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainRed,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await auth.logout();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil logout"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
