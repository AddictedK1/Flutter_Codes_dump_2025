class Bookmark {
  final String id;
  final String name;
  final String url;
  final String category;

  Bookmark({
    required this.id,
    required this.name,
    required this.url,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url, 'category': category};
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      category: json['category'] as String,
    );
  }

  Bookmark copyWith({String? id, String? name, String? url, String? category}) {
    return Bookmark(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      category: category ?? this.category,
    );
  }
}
