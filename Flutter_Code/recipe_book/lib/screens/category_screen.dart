import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'search_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Recipe> _recipes = [];
  List<Recipe> _allRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/recipes.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> recipesJson = jsonData['recipes'];

      final allRecipes = recipesJson
          .map((json) => Recipe.fromJson(json))
          .toList();

      setState(() {
        _allRecipes = allRecipes;
        _recipes = allRecipes
            .where((recipe) => recipe.category == widget.category)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading recipes: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(allRecipes: _allRecipes),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recipes found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: _recipes[index]);
                },
              ),
            ),
    );
  }
}
