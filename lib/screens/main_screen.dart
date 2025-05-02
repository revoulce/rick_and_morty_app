import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/screens/favorites_screen.dart';
import 'package:rick_and_morty_app/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [HomeScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Персонажи'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Избранное'),
        ],
      ),
    );
  }
}
