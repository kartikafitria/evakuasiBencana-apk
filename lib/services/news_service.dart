import 'package:dio/dio.dart';
import '../models/news_model.dart';

class NewsService {
  final Dio _dio = Dio();

  Future<List<NewsModel>> fetchNews() async {
    final response = await _dio.get(
      'https://data.bmkg.go.id/DataMKG/TEWS/gempadirasakan.json',
    );

    final List data = response.data['Infogempa']['gempa'];

    return data.map((e) => NewsModel.fromJson(e)).toList();
  }
}
