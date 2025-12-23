# Product Grid Catalog

A Flutter application that displays a product catalog with filtering, sorting, and favorites functionality.

## Features

✅ **Grid View Display**: Products displayed in a 2-column grid layout using `GridView.builder`
✅ **JSON Data Loading**: Products loaded from local JSON file with name, price, image, rating, category, description, and specs
✅ **Product Cards**: Each card displays product image, name, price, and star rating
✅ **Category Filtering**: Filter products by category using interactive Chip widgets at the top
✅ **Sort Options**: Sort products by price (ascending/descending) or default order
✅ **Product Details**: Tap any card to view full product details including large image, description, and specifications
✅ **Favorites System**: Add/remove products to favorites with heart icon toggle
✅ **Favorites Counter**: AppBar shows count of favorited products
✅ **Hero Animation**: Smooth image transitions between product card and detail screen

## Project Structure

```
lib/
├── main.dart                          # Main app entry with ProductCatalogScreen
├── models/
│   └── product.dart                   # Product model with JSON parsing
├── providers/
│   └── favorites_provider.dart        # State management for favorites
├── widgets/
│   └── product_card.dart              # Reusable product card widget
└── screens/
    └── product_detail_screen.dart     # Product detail view

assets/
└── products.json                      # Sample product data
```

## How to Run

1. Ensure Flutter is installed on your system
2. Navigate to the project directory
3. Get dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Sample Data

The app includes 12 sample products across 4 categories:
- **Electronics**: Headphones, Smart Watch, Bluetooth Speaker
- **Sports**: Running Shoes, Yoga Mat, Dumbbell Set
- **Fashion**: Leather Backpack, Sunglasses, Canvas Tote Bag
- **Home**: Coffee Maker, Desk Lamp, Air Purifier

## Technologies Used

- **Flutter**: UI framework
- **Provider**: State management for favorites
- **Hero Widget**: Animated transitions
- **GridView.builder**: Efficient grid layout
- **FilterChip**: Category filtering UI

## Screenshots

The app features:
- Clean, modern Material Design 3 UI
- Responsive grid layout
- Smooth animations and transitions
- Interactive filtering and sorting
- Real-time favorites tracking

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
