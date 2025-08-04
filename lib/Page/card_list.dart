import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/character_provider.dart';

class CardList extends StatelessWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Game text app 1")),
      body: Builder(
        builder: (_) {
          switch (provider.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.errors:
            return const Center(child: Text('Error for download'));
              case Status.success:
              return ListView.builder(
                itemCount: provider.characters.length,
                itemBuilder: (context , index){
                  final charecter = provider.characters[index];
                  return ListTile(
                    leading: Image.network(charecter.image),
                    title: Text(charecter.name),
                    subtitle: Text(charecter.gender),   
                  );
                },
              ) ;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => provider.fetchCharacter(),child: const Icon(Icons.refresh),),
    );
  }
}
