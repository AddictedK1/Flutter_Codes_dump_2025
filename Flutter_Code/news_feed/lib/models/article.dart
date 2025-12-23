class Article {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final String category;
  final DateTime date;
  final String fullContent;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.fullContent,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      fullContent: json['fullContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'imageUrl': imageUrl,
      'category': category,
      'date': date.toIso8601String(),
      'fullContent': fullContent,
    };
  }
}
