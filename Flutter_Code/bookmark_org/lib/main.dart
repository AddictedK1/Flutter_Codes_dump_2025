import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'models/bookmark.dart';
import 'services/bookmark_storage.dart';

void main() {
  runApp(const BookmarkOrganizerApp());
}

class BookmarkOrganizerApp extends StatelessWidget {
  const BookmarkOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookmark Organizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BookmarkHomePage(),
    );
  }
}

class BookmarkHomePage extends StatefulWidget {
  const BookmarkHomePage({super.key});

  @override
  State<BookmarkHomePage> createState() => _BookmarkHomePageState();
}

class _BookmarkHomePageState extends State<BookmarkHomePage> {
  final BookmarkStorage _storage = BookmarkStorage();
  List<Bookmark> _bookmarks = [];
  List<Bookmark> _filteredBookmarks = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_filterBookmarks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final bookmarks = await _storage.loadBookmarks();
    setState(() {
      _bookmarks = bookmarks;
      _filteredBookmarks = bookmarks;
      _isLoading = false;
    });
  }

  Future<void> _saveBookmarks() async {
    await _storage.saveBookmarks(_bookmarks);
  }

  void _filterBookmarks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBookmarks = _bookmarks;
      } else {
        _filteredBookmarks = _bookmarks.where((bookmark) {
          return bookmark.name.toLowerCase().contains(query) ||
              bookmark.url.toLowerCase().contains(query) ||
              bookmark.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Map<String, List<Bookmark>> _groupBookmarksByCategory() {
    final Map<String, List<Bookmark>> categorized = {};
    for (var bookmark in _filteredBookmarks) {
      categorized.putIfAbsent(bookmark.category, () => []).add(bookmark);
    }

    // Sort bookmarks alphabetically within each category
    categorized.forEach((key, value) {
      value.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    });

    return categorized;
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  void _showAddEditBookmarkDialog({Bookmark? bookmark}) {
    final isEditing = bookmark != null;
    final nameController = TextEditingController(text: bookmark?.name ?? '');
    final urlController = TextEditingController(text: bookmark?.url ?? '');
    String selectedCategory = bookmark?.category ?? 'General';
    final formKey = GlobalKey<FormState>();

    // Get existing categories
    final existingCategories =
        _bookmarks.map((b) => b.category).toSet().toList()..sort();
    if (!existingCategories.contains('General')) {
      existingCategories.insert(0, 'General');
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Bookmark' : 'Add Bookmark'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL',
                      border: OutlineInputBorder(),
                      hintText: 'https://example.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a URL';
                      }
                      final urlPattern = RegExp(
                        r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                      );
                      if (!urlPattern.hasMatch(value)) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      ...existingCategories.map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      ),
                      const DropdownMenuItem(
                        value: '__new__',
                        child: Text('+ New Category'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == '__new__') {
                        _showNewCategoryDialog((newCategory) {
                          setDialogState(() {
                            selectedCategory = newCategory;
                          });
                        });
                      } else {
                        setDialogState(() {
                          selectedCategory = value!;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    if (isEditing) {
                      final index = _bookmarks.indexWhere(
                        (b) => b.id == bookmark.id,
                      );
                      _bookmarks[index] = bookmark.copyWith(
                        name: nameController.text,
                        url: urlController.text,
                        category: selectedCategory,
                      );
                    } else {
                      _bookmarks.add(
                        Bookmark(
                          id:
                              DateTime.now().millisecondsSinceEpoch.toString() +
                              Random().nextInt(1000).toString(),
                          name: nameController.text,
                          url: urlController.text,
                          category: selectedCategory,
                        ),
                      );
                    }
                    _filterBookmarks();
                  });
                  _saveBookmarks();
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewCategoryDialog(Function(String) onCategoryCreated) {
    final categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                onCategoryCreated(categoryController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _deleteBookmark(Bookmark bookmark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bookmark'),
        content: Text('Are you sure you want to delete "${bookmark.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _bookmarks.removeWhere((b) => b.id == bookmark.id);
                _filterBookmarks();
              });
              _saveBookmarks();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportBookmarks() async {
    try {
      final filePath = await _storage.exportBookmarksToText(_bookmarks);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmarks exported to:\n$filePath'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting bookmarks: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorizedBookmarks = _groupBookmarksByCategory();
    final sortedCategories = categorizedBookmarks.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark Organizer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export Bookmarks',
            onPressed: _bookmarks.isEmpty ? null : _exportBookmarks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search bookmarks...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredBookmarks.isEmpty
                      ? Center(
                          child: Text(
                            _bookmarks.isEmpty
                                ? 'No bookmarks yet.\nTap + to add one!'
                                : 'No bookmarks found.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.builder(
                          itemCount: sortedCategories.length,
                          itemBuilder: (context, index) {
                            final category = sortedCategories[index];
                            final bookmarks = categorizedBookmarks[category]!;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ExpansionTile(
                                leading: const Icon(Icons.folder),
                                title: Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${bookmarks.length} bookmark${bookmarks.length != 1 ? 's' : ''}',
                                ),
                                children: bookmarks.map((bookmark) {
                                  return ListTile(
                                    leading: const Icon(Icons.bookmark),
                                    title: Text(bookmark.name),
                                    subtitle: Text(
                                      bookmark.url,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _showAddEditBookmarkDialog(
                                                bookmark: bookmark,
                                              ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                          onPressed: () =>
                                              _deleteBookmark(bookmark),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _launchUrl(bookmark.url),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditBookmarkDialog(),
        tooltip: 'Add Bookmark',
        child: const Icon(Icons.add),
      ),
    );
  }
}
