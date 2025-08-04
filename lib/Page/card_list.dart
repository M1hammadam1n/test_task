import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/character_provider.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CardProvider>(context, listen: false).fetchCharacter(),
    );

    //Запускает загрузку данных (fetchCharacter) автоматически при открытии экрана.
    //Делает это безопасно через Future.microtask, чтобы избежать ошибок с BuildContext.
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    //Получение провайдера
    return Scaffold(
      appBar: AppBar(title: Text("Game text app 1")),
      //it's just appbar
      body: Builder(
        builder: (_) {
          switch (provider.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            //loading → показывает индикатор загрузки.
            case Status.errors:
              return const Center(child: Text('Error for download'));
            //errors → показывает текст ошибки
            case Status.success:
              //success → отображает список персонажей.
              return ListView.builder(
                //Показывает каждого персонажа:
                itemCount: provider.characters.length,
                itemBuilder: (context, index) {
                  final charecter = provider.characters[index];
                  return ListTile(
                    leading: Image.network(charecter.image),
                    title: Text(charecter.name),
                    subtitle: Text(charecter.id.toString()),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
