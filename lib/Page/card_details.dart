import 'package:flutter/material.dart';
import 'package:test_task/domain/api_service.dart';
import 'package:test_task/domain/json.dart';
import 'package:test_task/theme/app_theme.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key, required this.id});
  final int id;
  //Это экран, на который ты переходишь, чтобы отобразить информацию о персонаже по его id.
  //id передаётся при вызове этого экрана и сохраняется как свойство widget.id.
  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  late Future<Character> _characterFuture;
  // Внутри State ты создаёшь Future, который будет содержать данные персонажа, полученные из API.
  @override
  void initState() {
    super.initState();
    _characterFuture = ApiService().getCharacterById(widget.id);
  }
  //Когда экран загружается, запускается initState, где ты вызываешь getCharecterById(widget.id) — это запрос к API, который возвращает Future<Character>.

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.55;
    //screenWidth и imageHeight — ты рассчитываешь размер изображения, чтобы сделать его адаптивным.
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.white),
        title: Text('Details', style: TextStyle(color: AppTheme.White30)),
        backgroundColor: AppTheme.black80,
      ),
      body: FutureBuilder<Character>(
        // FutureBuilder слушает Future (то есть запрос в API).
        //Внутри builder ты обрабатываешь разные состояния: загрузка, ошибка, данные готовы и т.д.
        future: _characterFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            //Если данные ещё загружаются, покажи крутилку.
          } else if (snapshot.hasError) {
            return Center(child: Text("error: ${snapshot.error}"));
            //Если при загрузке была ошибка, покажи её текст.
          } else if (snapshot.hasData) {
            final character = snapshot.data!;
            //Если данные пришли, сохраняешь персонажа в переменную character.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Image.network(
                        character.image,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  //Отображается картинка персонажа (Image.network).
                ),
                //Ниже — текстовые поля с его характеристиками:
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'name: ${character.name}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                    Text(
                      'gender: ${character.gender}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                    Text(
                      'id: ${character.id.toString()}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                    Text(
                      'species: ${character.species}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                    Text(
                      'status: ${character.status}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                    Text(
                      'created: ${character.created}',
                      style: TextStyle(fontSize: 25, color: AppTheme.white),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: Text('errors for date'));
            //Если snapshot не в ошибке и не с данными — значит что-то пошло не так, выводится "errors for date".
          }
        },
      ),
    );
  }
}
