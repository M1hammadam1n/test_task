import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task/Page/card_details.dart';
import 'package:test_task/Page/character_provider.dart';
import 'package:test_task/theme/app_theme.dart';

class CardList extends StatefulWidget {
  const CardList({super.key});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CardProvider>(context, listen: false).fetchCharacter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Рик и Морти",
          style: TextStyle(color: AppTheme.white54),
        ),
        backgroundColor: AppTheme.black80,
      ),
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
          Builder(
            builder: (_) {
              switch (provider.status) {
                case Status.loading:
                  return const Center(child: CircularProgressIndicator());
                case Status.errors:
                  return const Center(child: Text('Error for download'));
                case Status.success:
                  return ListView.builder(
                    itemCount: provider.characters.length,
                    itemBuilder: (context, index) {
                      final character = provider.characters[index];
                      final favoriteProvider = Provider.of<FavoriteProvider>(
                        context,
                      );
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
