import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_media_ui/models/post.dart';
import 'package:social_media_ui/data/posts_data.dart';
import 'package:social_media_ui/widgets/post_card.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  List<Post> posts = [];
  Map<String, bool> likeStates = {};
  bool isLoading = true;
  int newPostCounter = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  void _loadInitialPosts() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final List<dynamic> jsonData = json.decode(samplePostsJson);
      setState(() {
        posts = jsonData.map((json) => Post.fromJson(json)).toList();
        // Initialize like states as false for all posts
        for (var post in posts) {
          likeStates[post.id] = false;
        }
        isLoading = false;
      });
    });
  }

  Future<void> _handleRefresh() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final List<dynamic> newJsonData = json.decode(newPostsJson);
    final List<Post> newPosts = newJsonData.map((json) {
      // Create unique IDs for new posts on each refresh
      final jsonCopy = Map<String, dynamic>.from(json);
      jsonCopy['id'] = '${json['id']}_$newPostCounter';
      jsonCopy['timestamp'] = DateTime.now().toIso8601String();
      return Post.fromJson(jsonCopy);
    }).toList();

    setState(() {
      // Add new posts to the beginning of the list
      posts.insertAll(0, newPosts);
      // Initialize like states for new posts
      for (var post in newPosts) {
        likeStates[post.id] = false;
      }
      newPostCounter++;
    });
  }

  void _toggleLike(String postId) {
    setState(() {
      final currentState = likeStates[postId] ?? false;
      likeStates[postId] = !currentState;

      // Find the post and update like count
      final postIndex = posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        if (!currentState) {
          posts[postIndex].likes++;
        } else {
          posts[postIndex].likes--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Social Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.messenger_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: posts.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text('No posts yet')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          isLiked: likeStates[post.id] ?? false,
                          onLike: () => _toggleLike(post.id),
                        );
                      },
                    ),
            ),
    );
  }
}
