import 'dart:convert';
import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/Page/card_details.dart';
import 'package:test_task/Page/character_provider.dart';
import 'package:test_task/domain/image_state.dart';
import 'package:test_task/theme/app_theme.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    //Метод initState вызывается один раз при создании виджета.
    super.initState();
    Future.microtask(() async {
      //Асинхронная задача ставится в очередь — microtask запускается после завершения синхронизации виджета.
      final provider = Provider.of<CardProvider>(context, listen: false);
      //Получаем CardProvider, который содержит персонажей и их загрузку.
      await provider.fetchCharacter();
      //Загружаем персонажей с API.
      await saveAllImages(provider.characters);
      //Сохраняем изображения всех персонажей (функция saveAllImages предполагается где-то определена — ты её не показал)
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    //Получаем доступ к CardProvider (с listen: true по умолчанию).
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Рик и Морти",
          style: TextStyle(color: AppTheme.white54),
        ),
        backgroundColor: AppTheme.black80,
      ),
      //Стандартный AppBar с заголовком и стилем из темы.
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://vsthemes.org/uploads/posts/2019-03/1195118549.webp",
            fit: BoxFit.cover,
          ),
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
                color: Colors.black.withOpacity(0.7),
                alignment: Alignment.center,
              ),
            ),
          ),
          //Добавляется затемнение (прозрачный чёрный цвет), и фильтр размытия (хотя sigmaX/Y = 0.0, так что размытия пока нет).
          //Фоновое изображение на весь экран.
          Builder(
            builder: (_) {
              switch (provider.status) {
                //Используем switch для проверки статуса загрузки персонажей:
                case Status.loading:
                  return const Center(child: CircularProgressIndicator());
                //Показываем индикатор загрузки.
                case Status.errors:
                  return const Center(child: Text('Error for download'));
                //Показываем сообщение об ошибке.
                case Status.success:
                  return ListView.builder(
                    itemCount: provider.characters.length,
                    itemBuilder: (context, index) {
                      final character = provider.characters[index];
                      //Показываем список карточек персонажей.
                      final favoriteProvider = Provider.of<FavoriteProvider>(
                        context,
                      );
                      final isFav = favoriteProvider.isFavorite(character.id);
                      //Получаем FavoriteProvider и проверяем, добавлен ли персонаж в избранное.
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CardDetails(id: character.id),
                            ),
                          );
                        },
                        //Оборачиваем карточку в GestureDetector — при нажатии переходим на экран CardDetails.
                        child: ListTile(
                          leading: Image.network(character.image, width: 50),
                          title: Text(
                            character.name,
                            style: TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Отображаем имя персонажа.
                          subtitle: Text(
                            'Status: ${character.status}',
                            style: TextStyle(
                              color: AppTheme.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Отображаем статус персонажа.
                          trailing: IconButton(
                            icon:
                                isFav
                                    ? Image.asset(
                                      'assets/icons/favourites.png',
                                      width: 24,
                                      height: 24,
                                    )
                                    : Image.asset(
                                      'assets/icons/favorites.png',
                                      width: 24,
                                      height: 24,
                                      color: AppTheme.white,
                                    ),// Показываем иконку избранного в зависимости от состояния.
                            onPressed: () async {
                              favoriteProvider.toggleFavorite(character.id);
// Добавляем или удаляем персонажа из избранного.
                              // Сохранить изображение персонажа в SharedPreferences
                              final response = await HttpClient().getUrl(
                                Uri.parse(character.image),
                              );
                              // Получаем изображение персонажа по URL.
                              // Преобразуем его в байты и сохраняем в SharedPreferences
                              // (предполагается, что функция saveAllImages уже реализована).
                              // Сохраняем изображение в формате base64.
                              // Это нужно для того, чтобы при повторном открытии приложения
                              // изображение было доступно без повторного запроса к сети.
                              // Получаем байты изображения.
                              // Преобразуем байты в base64 строку.
                              // Сохраняем base64 строку в SharedPreferences.
                              // Получаем SharedPreferences для сохранения изображения.
                              // Получаем байты изображения.
                              final imageBytes = await response.close().then(
                                (res) => res.fold<List<int>>(
                                  [],
                                  (p, e) => p..addAll(e),
                                ),
                              );
                              
                              final base64Image = base64Encode(imageBytes);

                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                'saved_image_${character.id}',
                                base64Image,
                              );
                              // Сохраняем изображение в SharedPreferences
                              // с ключом 'saved_image_${character.id}'.
                              // Это нужно для того, чтобы при повторном открытии приложения
                              // изображение было доступно без повторного запроса к сети.
                              // Получаем SharedPreferences для сохранения изображения.
                            },
                          ),
                        ),
                      );
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
