class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final double rating;
  final String category;
  final String description;
  final List<String> specs;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
    required this.description,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      specs: (json['specs'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'rating': rating,
      'category': category,
      'description': description,
      'specs': specs,
    };
  }
}
