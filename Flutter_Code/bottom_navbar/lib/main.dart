import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Nav App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = const [
    'Home',
    'Explore',
    'Favorites',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _loadLastSection();
  }

  Future<void> _loadLastSection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSection = prefs.getInt('last_section') ?? 0;
      setState(() {
        _currentIndex = lastSection;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLastSection(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_section', index);
    } catch (e) {
      // Handle error silently
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _saveLastSection(index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          _saveLastSection(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 2,
          centerTitle: true,
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
