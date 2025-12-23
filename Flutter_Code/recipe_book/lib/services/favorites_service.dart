import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_recipes';

  // Get all favorite recipe IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Check if a recipe is a favorite
  Future<bool> isFavorite(String recipeId) async {
    final favorites = await getFavorites();
    return favorites.contains(recipeId);
  }

  // Add a recipe to favorites
  Future<void> addFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(recipeId)) {
      favorites.add(recipeId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Remove a recipe from favorites
  Future<void> removeFavorite(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(recipeId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String recipeId) async {
    final isFav = await isFavorite(recipeId);
    if (isFav) {
      await removeFavorite(recipeId);
      return false;
    } else {
      await addFavorite(recipeId);
      return true;
    }
  }
}
