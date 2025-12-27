import 'package:flutter/material.dart';
import 'evac_map_screen.dart';
import 'report/report_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Dashboard Evac Map"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.redAccent, Colors.deepOrange],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pantau titik kumpul dan jalur evakuasi di sekitar Anda.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Titik Kumpul Evakuasi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ================= LIST TITIK EVAKUASI =================
            Expanded(
              child: ListView.builder(
                itemCount: evacuationPoints.length,
                itemBuilder: (context, index) {
                  final item = evacuationPoints[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        item['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(item['address']!),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EvacMapScreen(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 1) {
            // KE EVAC MAP
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EvacMapScreen(),
              ),
            );
          } else if (index == 2) {
            // ✅ KE LAPORAN (CRUD)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ReportListScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Evac Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: "Laporan",
          ),
        ],
      ),
    );
  }
}

// ================= DUMMY DATA =================
final List<Map<String, String>> evacuationPoints = [
  {
    "name": "Lapangan Merdeka",
    "address": "Jl. Merdeka No. 1",
  },
  {
    "name": "Gedung Serbaguna",
    "address": "Jl. Raya Utama No. 12",
  },
  {
    "name": "Balai Desa",
    "address": "Jl. Desa Aman No. 5",
  },
];
