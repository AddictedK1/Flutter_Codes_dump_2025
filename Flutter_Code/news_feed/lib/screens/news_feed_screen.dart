import 'package:flutter/material.dart';
import '../models/article.dart';
import '../data/articles_data.dart';
import '../widgets/article_card.dart';
import '../widgets/sliver_category_header.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<Article> allArticles = [];

  @override
  void initState() {
    super.initState();
    allArticles = getSampleArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Article> get filteredArticles {
    List<Article> articles = allArticles;

    // Filter by category
    if (selectedCategory != 'All') {
      articles = articles
          .where((article) => article.category == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      articles = articles
          .where(
            (article) =>
                article.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return articles;
  }

  int _getArticleCount(String category) {
    if (category == 'All') {
      return allArticles.length;
    }
    return allArticles.where((article) => article.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Tech', 'Sports', 'Business'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Floating SliverAppBar
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 120,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'News Feed',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search articles by title...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          // Category Filter (SliverPersistentHeader)
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverCategoryHeader(
              minHeight: 80,
              maxHeight: 80,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = selectedCategory == category;
                          final articleCount = _getArticleCount(category);

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(
                                '$category ($articleCount)',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.deepPurple,
                              checkmarkColor: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Results Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${filteredArticles.length} articles found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Articles List
          filteredArticles.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No articles found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try different search terms'
                              : 'Check back later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return ArticleCard(article: filteredArticles[index]);
                  }, childCount: filteredArticles.length),
                ),
          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
