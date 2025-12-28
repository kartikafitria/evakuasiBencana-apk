import 'package:flutter/material.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Gempa"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              news.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text("Magnitudo: ${news.magnitude}"),
            Text("Lokasi: ${news.location}"),
            Text("Waktu: ${news.time}"),

            const SizedBox(height: 16),

            const Text(
              "Dirasakan di:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(news.felt),
          ],
        ),
      ),
    );
  }
}
