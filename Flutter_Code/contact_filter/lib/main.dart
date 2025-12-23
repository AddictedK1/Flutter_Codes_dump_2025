import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Contact model class
class Contact {
  final String id;
  final String name;
  final String phone;
  final String category;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
  });
}

// Category enum
enum ContactCategory {
  all('All'),
  family('Family'),
  friends('Friends'),
  work('Work');

  final String label;
  const ContactCategory(this.label);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Filter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // Sample contacts - 20 contacts with different categories
  final List<Contact> _allContacts = [
    // Family (7 contacts)
    Contact(id: '1', name: 'Alice Johnson', phone: '555-0101', category: 'Family'),
    Contact(id: '2', name: 'Bob Smith', phone: '555-0102', category: 'Family'),
    Contact(id: '3', name: 'Carol Williams', phone: '555-0103', category: 'Family'),
    Contact(id: '4', name: 'David Brown', phone: '555-0104', category: 'Family'),
    Contact(id: '5', name: 'Emma Davis', phone: '555-0105', category: 'Family'),
    Contact(id: '6', name: 'Frank Miller', phone: '555-0106', category: 'Family'),
    Contact(id: '7', name: 'Grace Wilson', phone: '555-0107', category: 'Family'),
    
    // Friends (7 contacts)
    Contact(id: '8', name: 'Henry Moore', phone: '555-0201', category: 'Friends'),
    Contact(id: '9', name: 'Iris Taylor', phone: '555-0202', category: 'Friends'),
    Contact(id: '10', name: 'Jack Anderson', phone: '555-0203', category: 'Friends'),
    Contact(id: '11', name: 'Karen Thomas', phone: '555-0204', category: 'Friends'),
    Contact(id: '12', name: 'Leo Jackson', phone: '555-0205', category: 'Friends'),
    Contact(id: '13', name: 'Mia White', phone: '555-0206', category: 'Friends'),
    Contact(id: '14', name: 'Nathan Harris', phone: '555-0207', category: 'Friends'),
    
    // Work (6 contacts)
    Contact(id: '15', name: 'Olivia Martin', phone: '555-0301', category: 'Work'),
    Contact(id: '16', name: 'Peter Thompson', phone: '555-0302', category: 'Work'),
    Contact(id: '17', name: 'Quinn Garcia', phone: '555-0303', category: 'Work'),
    Contact(id: '18', name: 'Rachel Martinez', phone: '555-0304', category: 'Work'),
    Contact(id: '19', name: 'Samuel Robinson', phone: '555-0305', category: 'Work'),
    Contact(id: '20', name: 'Tina Clark', phone: '555-0306', category: 'Work'),
  ];

  // Set for storing favorite contact IDs (demonstrates Set for unique IDs)
  final Set<String> _favoriteIds = {};
  
  ContactCategory _selectedCategory = ContactCategory.all;
  String _searchQuery = '';
  bool _sortAscending = true;

  // Filter contacts using where()
  List<Contact> get _filteredContacts {
    List<Contact> contacts = _allContacts;
    
    // Filter by category using where()
    if (_selectedCategory != ContactCategory.all) {
      contacts = contacts.where((contact) => 
        contact.category == _selectedCategory.label
      ).toList();
    }
    
    // Filter by search query using contains()
    if (_searchQuery.isNotEmpty) {
      contacts = contacts.where((contact) => 
        contact.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Sort by name using sort()
    contacts.sort((a, b) {
      final comparison = a.name.compareTo(b.name);
      return _sortAscending ? comparison : -comparison;
    });
    
    return contacts;
  }

  // Get count of contacts per category using map grouping
  Map<String, int> get _categoryStats {
    final Map<String, int> stats = {};
    for (var contact in _allContacts) {
      stats[contact.category] = (stats[contact.category] ?? 0) + 1;
    }
    return stats;
  }

  void _toggleFavorite(String contactId) {
    setState(() {
      if (_favoriteIds.contains(contactId)) {
        _favoriteIds.remove(contactId);
      } else {
        _favoriteIds.add(contactId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = _filteredContacts;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Filter App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_sortAscending ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            tooltip: _sortAscending ? 'Sort A-Z' : 'Sort Z-A',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Category filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: ContactCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Category statistics
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Family', _categoryStats['Family'] ?? 0, Colors.green),
                _buildStatItem('Friends', _categoryStats['Friends'] ?? 0, Colors.orange),
                _buildStatItem('Work', _categoryStats['Work'] ?? 0, Colors.blue),
                _buildStatItem('Favorites', _favoriteIds.length, Colors.red),
              ],
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${filteredContacts.length} contacts found',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Contact list
          Expanded(
            child: filteredContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No contacts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      final isFavorite = _favoriteIds.contains(contact.id);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(contact.category),
                            child: Text(
                              contact.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(contact.phone),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(
                                  contact.category,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: _getCategoryColor(contact.category).withOpacity(0.2),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.star : Icons.star_border,
                              color: isFavorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(contact.id),
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Family':
        return Colors.green;
      case 'Friends':
        return Colors.orange;
      case 'Work':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

