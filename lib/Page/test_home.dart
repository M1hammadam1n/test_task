import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  List<dynamic> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Date test"), centerTitle: true),

      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user['name'];
          final Picture = user['image'];
          final gender = user['gender'];
          return ListTile(
            leading: Image.network(Picture),
            title: Text(name),
            subtitle: Text(gender),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: getDate),
    );
  }

  void getDate() async {
    const url = 'https://rickandmortyapi.com/api/character';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });
  }
}
