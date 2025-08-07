import 'package:flutter/material.dart';
import 'package:test_task/Page/card_list.dart';
import 'package:test_task/Page/favorite.dart';
import 'package:test_task/theme/app_theme.dart';

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarExample(),
    );
    //Создаёт MaterialApp с BottomNavigationBarExample в качестве домашней страницы.
    //debugShowCheckedModeBanner: false убирает баннер отладки в правом верхнем углу.
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});
  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    CardList(),
    FavoritePage(),
  ];
// Список виджетов для отображения в зависимости от выбранного индекса. 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
// Метод для обновления состояния при выборе элемента навигации.  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // Отображает нижнюю навигационную панель без меток.  
        backgroundColor: AppTheme.black80,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icons8-rick-sanchez-100.png',
              width: 26,
              height: 26,
            ),
            // Иконка для первого элемента навигации (Rick Sanchez).

            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icons8-star-96.png',
              width: 26,
              height: 26,
            ),
            // Иконка для второго элемента навигации (Избранное).
            // Изображение звезды для избранных персонажей.
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Обработчик нажатия на элемент навигации.
      ),
    );
  }
}
