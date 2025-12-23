import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  int get favoritesCount => _favoriteIds.length;

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void addFavorite(String productId) {
    _favoriteIds.add(productId);
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favoriteIds.remove(productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
