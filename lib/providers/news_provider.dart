import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _service = NewsService();

  List<NewsModel> newsList = [];
  bool isLoading = false;

  Future<void> fetchNews() async {
    isLoading = true;
    notifyListeners();

    try {
      newsList = await _service.fetchNews();
    } catch (e) {
      debugPrint("ERROR BMKG: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
