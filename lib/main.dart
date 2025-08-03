import 'package:dio/dio.dart' show Dio;
import 'package:flutter/material.dart';
import 'package:test_task/Page/test_home.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TestHome());
  }
}
