import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/firebase_service.dart';
import '../widgets/post_card.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: FirebaseService.postsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet. Tap + to add one.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(post: posts[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreatePostScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
