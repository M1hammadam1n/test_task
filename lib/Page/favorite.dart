import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/card_details.dart';
import 'package:test_task/Page/character_provider.dart';
import 'package:test_task/domain/api_service.dart';
import 'package:test_task/domain/json.dart';
import 'package:test_task/theme/app_theme.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoriteIds = favoriteProvider.favorites;
    // Получаем список избранных персонажей из FavoriteProvider.

    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        title: Text('Избранные', style: TextStyle(color: AppTheme.White30)),
        backgroundColor: AppTheme.black80,
      ), // Создаём AppBar с заголовком "Избранные" и стилем из темы.
      // AppBar с заголовком "Избранные" и цветом из темы.
      body: Stack(
        children: [
          Image.network(
            'https://cs11.pikabu.ru/post_img/big/2019/11/29/6/1575016478113464227.png',
            fit: BoxFit.cover,
          ),
          // Фоновое изображение для страницы избранных персонажей.
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: Container(
                color: Colors.black.withOpacity(0.7),
                alignment: Alignment.center,
              ),
            ),
          ),
          // Применяем эффект размытия к фону с помощью BackdropFilter.
          // Контейнер с полупрозрачным черным фоном.
          // Этот контейнер используется для затемнения фона и создания эффекта размытия.
          // Он занимает всю область экрана и центрирует содержимое.
          // Центрируем содержимое внутри размытого контейнера.
          favoriteIds.isEmpty
              ? const Center(child: Text('Список избранного пуст'))
              : ListView.builder(
                itemCount: favoriteIds.length,
                itemBuilder: (context, index) {
                  // Создаём ListView для отображения избранных персонажей.
                  // Используем FutureBuilder для асинхронной загрузки данных о персонаже по  id.
                  // Получаем id избранного персонажа по индексу.
                  final id = favoriteIds[index];
                  return FutureBuilder<Character>(
                    future: ApiService().getCharacterById(id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text('Загрузка...'));
                      } else if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Ошибка: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        // Если данные успешно загружены, отображаем карточку персонажа.
                        final character = snapshot.data!;
                        final isFav = favoriteProvider.isFavorite(character.id);
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

                          // При нажатии на карточку персонажа, переходим на экран CardDetails.
                          // Оборачиваем карточку в GestureDetector — при нажатии переходим на экран CardDetails.
                          child: ListTile(
                            leading: Image.network(character.image, width: 50),
                            title: Text(
                              character.name,
                              style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Отображаем имя персонажа.
                            // Отображаем статус персонажа.
                            subtitle: Text(
                              'Status: ${character.status}',
                              style: TextStyle(
                                color: AppTheme.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            // Показываем иконку избранного в зависимости от состояния.
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
                                      ),
                              onPressed: () {
                                favoriteProvider.toggleFavorite(character.id);
                              },
                            ),
                            // Добавляем или удаляем персонажа из избранного.
                          ),
                        );
                      } else {
                        return const ListTile(title: Text('Нет данных'));
                      }
                      // Если данные не загружены, отображаем сообщение "Нет данных".
                    },
                  );
                },
              ),
        ],
      ),
    );
  }
}
