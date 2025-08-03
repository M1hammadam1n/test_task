import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: Column(
        children: [
          SizedBox(
            height: 700,
            child: ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          height: 100,
                          child: Image.network(
                            'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("name", style: TextStyle(fontSize: 25)),
                              Text("Text-1", style: TextStyle(fontSize: 25)),
                              Text("Text-2", style: TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.account_box),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
