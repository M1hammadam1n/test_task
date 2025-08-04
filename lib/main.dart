import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/character_provider.dart';
import 'package:test_task/Page/card_list.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => CardProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CardList(),
    ),
    );
  }
}
