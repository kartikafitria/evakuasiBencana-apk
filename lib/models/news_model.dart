class NewsModel {
  final String title;
  final String magnitude;
  final String location;
  final String time;
  final String felt;

  NewsModel({
    required this.title,
    required this.magnitude,
    required this.location,
    required this.time,
    required this.felt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: "Gempa ${json['Wilayah']}",
      magnitude: json['Magnitude'],
      location: json['Wilayah'],
      time: "${json['Tanggal']} ${json['Jam']}",
      felt: json['Dirasakan'],
    );
  }
}
