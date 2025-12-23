import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/favorites_provider.dart';
import 'widgets/product_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        title: 'Product Grid Catalog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ProductCatalogScreen(),
      ),
    );
  }
}

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _sortOrder = 'none'; // 'none', 'asc', 'desc'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/products.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _allProducts = jsonData.map((json) => Product.fromJson(json)).toList();
        _filteredProducts = List.from(_allProducts);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  List<String> _getCategories() {
    final categories = _allProducts.map((p) => p.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredProducts = List.from(_allProducts);
      } else {
        _filteredProducts =
            _allProducts.where((p) => p.category == category).toList();
      }
      _applySorting();
    });
  }

  void _applySorting() {
    if (_sortOrder == 'asc') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortOrder == 'desc') {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  void _changeSortOrder(String order) {
    setState(() {
      _sortOrder = order;
      _applySorting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  // Could navigate to favorites screen
                },
              ),
              if (favoritesProvider.favoritesCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${favoritesProvider.favoritesCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _changeSortOrder,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'none',
                child: Text('Default'),
              ),
              const PopupMenuItem(
                value: 'asc',
                child: Text('Price: Low to High'),
              ),
              const PopupMenuItem(
                value: 'desc',
                child: Text('Price: High to Low'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category filter chips
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    children: _getCategories().map((category) {
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) => _filterByCategory(category),
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Product grid
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: _filteredProducts[index],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}