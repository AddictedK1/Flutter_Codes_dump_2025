class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.color,
  });

  // Sample categories
  static List<Category> getSampleCategories() {
    return [
      Category(
        id: '1',
        name: 'Technology',
        description: 'Latest gadgets and tech innovations',
        imageUrl: 'https://picsum.photos/seed/tech/400/300',
        color: '0xFF2196F3',
      ),
      Category(
        id: '2',
        name: 'Food',
        description: 'Delicious recipes and culinary adventures',
        imageUrl: 'https://picsum.photos/seed/food/400/300',
        color: '0xFFFF9800',
      ),
      Category(
        id: '3',
        name: 'Travel',
        description: 'Explore beautiful destinations worldwide',
        imageUrl: 'https://picsum.photos/seed/travel/400/300',
        color: '0xFF4CAF50',
      ),
      Category(
        id: '4',
        name: 'Sports',
        description: 'Athletic activities and competitions',
        imageUrl: 'https://picsum.photos/seed/sports/400/300',
        color: '0xFFF44336',
      ),
      Category(
        id: '5',
        name: 'Music',
        description: 'Sounds, rhythms, and melodies',
        imageUrl: 'https://picsum.photos/seed/music/400/300',
        color: '0xFF9C27B0',
      ),
      Category(
        id: '6',
        name: 'Art',
        description: 'Creative expressions and masterpieces',
        imageUrl: 'https://picsum.photos/seed/art/400/300',
        color: '0xFFE91E63',
      ),
      Category(
        id: '7',
        name: 'Science',
        description: 'Discoveries and experiments',
        imageUrl: 'https://picsum.photos/seed/science/400/300',
        color: '0xFF00BCD4',
      ),
      Category(
        id: '8',
        name: 'Fashion',
        description: 'Style trends and design',
        imageUrl: 'https://picsum.photos/seed/fashion/400/300',
        color: '0xFFFF5722',
      ),
    ];
  }
}
