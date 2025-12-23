class Recipe {
  final String id;
  final String name;
  final String category; // breakfast, lunch, dinner
  final String imageUrl;
  final int prepTimeMinutes;
  final int servings;
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.prepTimeMinutes,
    required this.servings,
    required this.ingredients,
    required this.steps,
  });

  // Factory constructor for creating a Recipe from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      servings: json['servings'] as int,
      ingredients: List<String>.from(json['ingredients'] as List),
      steps: List<String>.from(json['steps'] as List),
    );
  }

  // Method to convert Recipe to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'prepTimeMinutes': prepTimeMinutes,
      'servings': servings,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
