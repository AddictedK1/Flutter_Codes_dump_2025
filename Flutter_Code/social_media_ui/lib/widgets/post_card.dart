import 'package:flutter/material.dart';
import 'package:social_media_ui/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, username, timestamp
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post.avatar),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeago.format(post.timestamp),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert, color: Colors.grey[600]),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(post.content, style: const TextStyle(fontSize: 14)),
          ),

          // Image with timestamp overlay (if image exists)
          if (post.imageUrl != null) ...[
            const SizedBox(height: 12),
            Stack(
              children: [
                Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      timeago.format(post.timestamp),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Like and comment counts
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Like button
                InkWell(
                  onTap: onLike,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Comment count
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Share icon
                Icon(Icons.share_outlined, color: Colors.grey[600], size: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
