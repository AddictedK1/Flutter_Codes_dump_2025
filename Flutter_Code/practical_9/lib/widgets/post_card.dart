import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!, fit: BoxFit.cover),
              ),
            if (post.imageUrl != null) const SizedBox(height: 8),
            Text(post.content),
            const SizedBox(height: 8),
            Text(
              '${post.createdAt.toLocal()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
