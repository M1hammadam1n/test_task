import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/character_provider.dart';
import 'package:test_task/Page/navigate.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        //Регистрирует CardProvider в дереве виджетов.
        //Делает его доступным в любом месте ниже по дереву.
        //create: (_) => CardProvider() — создаёт экземпляр провайдера.
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const BottomNavigationBarExampleApp(),
      ),
    );
  }
}
