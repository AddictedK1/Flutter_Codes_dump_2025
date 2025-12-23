class Post {
  final String id;
  final String username;
  final String avatar;
  final DateTime timestamp;
  final String content;
  final String? imageUrl;
  int likes;
  final int comments;

  Post({
    required this.id,
    required this.username,
    required this.avatar,
    required this.timestamp,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      timestamp: DateTime.parse(json['timestamp']),
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
    };
  }
}
