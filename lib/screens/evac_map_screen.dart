import 'package:flutter/material.dart';

class EvacMapScreen extends StatelessWidget {
  const EvacMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evacuation Map"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [

          // MAP PLACEHOLDER
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Peta Evakuasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "(Google Maps akan ditampilkan di sini)",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Titik Kumpul Terdekat",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // LIST TITIK KUMPUL
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: evacPoints.length,
              itemBuilder: (context, index) {
                final item = evacPoints[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                    ),
                    title: Text(item['name']!),
                    subtitle: Text(item['address']!),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text("Rute"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EvacDetailScreen(
                              name: item['name']!,
                              address: item['address']!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// DETAIL SCREEN (SIMULASI RUTE)
class EvacDetailScreen extends StatelessWidget {
  final String name;
  final String address;

  const EvacDetailScreen({
    super.key,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Evakuasi"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(address),
            const SizedBox(height: 20),

            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Simulasi Rute Evakuasi\n(Map Navigation)",
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.navigation),
              label: const Text("Mulai Navigasi"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigasi evakuasi dimulai"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// DUMMY DATA
final List<Map<String, String>> evacPoints = [
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
