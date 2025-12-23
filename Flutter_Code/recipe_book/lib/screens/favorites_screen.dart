import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../services/favorites_service.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all recipes
      final String jsonString = await rootBundle.loadString(
        'assets/recipes.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> recipesJson = jsonData['recipes'];
      final allRecipes = recipesJson
          .map((json) => Recipe.fromJson(json))
          .toList();

      // Get favorite IDs
      final favoriteIds = await _favoritesService.getFavorites();

      // Filter recipes to only favorites
      final favorites = allRecipes
          .where((recipe) => favoriteIds.contains(recipe.id))
          .toList();

      setState(() {
        _favoriteRecipes = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading favorites: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAVORITES',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some recipes to your favorites!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(recipe: _favoriteRecipes[index]);
                  },
                ),
              ),
            ),
    );
  }
}
