import 'package:flutter/material.dart';
import 'package:test_task/Page/favorite_Page.dart';
import 'package:test_task/Page/home_page.dart';

class BottomNav extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const BottomNav({super.key, required this.onToggleTheme});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(onToggleTheme: widget.onToggleTheme),
      const FavoritePage(),
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
