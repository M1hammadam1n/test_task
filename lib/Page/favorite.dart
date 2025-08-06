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

    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        title: Text('Избранные', style: TextStyle(color: AppTheme.White30)),
        backgroundColor: AppTheme.black80,
      ),
      body: Stack(
        children: [
          Image.network(
            'https://cs11.pikabu.ru/post_img/big/2019/11/29/6/1575016478113464227.png',
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
          favoriteIds.isEmpty
              ? const Center(child: Text('Список избранного пуст'))
              : ListView.builder(
                itemCount: favoriteIds.length,
                itemBuilder: (context, index) {
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
                          child: ListTile(
                            leading: Image.network(character.image, width: 50),
                            title: Text(
                              character.name,
                              style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Status: ${character.status}',
                              style: TextStyle(
                                color: AppTheme.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
                          ),
                        );
                      } else {
                        return const ListTile(title: Text('Нет данных'));
                      }
                    },
                  );
                },
              ),
        ],
      ),
    );
  }
}
