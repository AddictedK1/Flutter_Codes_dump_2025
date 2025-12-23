import 'package:flutter/material.dart';
import '../models/category.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Category> _favorites = [];
  final List<Category> _allCategories = Category.getSampleCategories();

  void _addFavorite(Category category) {
    if (!_favorites.any((fav) => fav.id == category.id)) {
      setState(() {
        _favorites.add(category);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${category.name} added to favorites'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeFavorite(Category category) {
    setState(() {
      _favorites.removeWhere((fav) => fav.id == category.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category.name} removed from favorites'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _addFavorite(category);
          },
        ),
      ),
    );
  }

  void _showAddFavoriteDialog() {
    final availableCategories = _allCategories
        .where((cat) => !_favorites.any((fav) => fav.id == cat.id))
        .toList();

    if (availableCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All categories are already in favorites!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Favorites'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableCategories.length,
            itemBuilder: (context, index) {
              final category = availableCategories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(int.parse(category.color)),
                  child: const Icon(Icons.category, color: Colors.white),
                ),
                title: Text(category.name),
                subtitle: Text(category.description),
                onTap: () {
                  Navigator.pop(context);
                  _addFavorite(category);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_favorites.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add categories to your favorites',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showAddFavoriteDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Favorite'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final category = _favorites[index];
                return Dismissible(
                  key: Key(category.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    _removeFavorite(category);
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(int.parse(category.color)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.favorite, color: Colors.white),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(category.description),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        onPressed: () => _removeFavorite(category),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        if (_favorites.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddFavoriteDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add More Favorites'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
