import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory Post.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Post(
      id: doc.id,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
