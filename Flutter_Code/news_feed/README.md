# News Feed App

A modern Flutter news feed application featuring advanced scrolling with Slivers, category filtering, and search functionality.

## Features

### 📱 User Interface

- **CustomScrollView with Slivers** - Smooth, efficient scrolling experience
- **Floating SliverAppBar** - App bar that floats and snaps into view
- **SliverPersistentHeader** - Pinned category filter chips that stay visible while scrolling
- **SliverList** - Efficient list rendering for articles

### 🗂️ Category Management

- **Three Categories**: Tech, Sports, and Business
- **Category Filtering** - Filter articles by category with a single tap
- **Article Count Display** - Shows the number of articles per category
- **All Category** - View all articles from all categories

### 🔍 Search Functionality

- **Search by Title** - Find articles by searching in the title
- **Real-time Filtering** - Results update as you type
- **Clear Search** - Quick button to clear the search query

### 📰 Article Display

- **Card Layout** - Beautiful card design for each article
- **Network Images** - Articles feature images loaded from the internet
- **Date Formatting** - Smart date display (e.g., "2 hours ago", "Yesterday", "Dec 22, 2024")
- **Category Badges** - Color-coded badges for quick category identification
  - 🔵 Tech - Blue
  - 🟢 Sports - Green
  - 🟠 Business - Orange

### 📖 Article Details

- **Full Article Screen** - Tap any article to read the full content
- **Expandable AppBar** - Large header image that collapses on scroll
- **Formatted Content** - Well-structured article content with summary and full text

### 📊 Data Management

- **10 Sample Articles** - Pre-loaded with diverse news content
- **JSON-based Model** - Easy to extend with real API integration

## Technical Implementation

### Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   └── article.dart                    # Article data model
├── data/
│   └── articles_data.dart              # Sample articles data
├── screens/
│   ├── news_feed_screen.dart           # Main news feed with CustomScrollView
│   └── article_detail_screen.dart      # Full article view
└── widgets/
    ├── article_card.dart               # Article card widget
    └── sliver_category_header.dart     # Custom persistent header delegate
```

### Key Technologies

- **Flutter Material 3** - Modern UI design
- **Slivers** - Advanced scrolling effects
- **NetworkImage** - Remote image loading with error handling
- **intl Package** - Date formatting

## Usage

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```
