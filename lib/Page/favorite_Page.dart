import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/Bloc/favorite_cubit.dart';
import 'package:test_task/components/card.dart';
import 'package:test_task/domain/json.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранные персонажи')),
      body: BlocBuilder<FavoriteCubit, List<RickMorty>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(child: Text('Нет избранных'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(
                character: character,
                isFavorite: true,
                onFavoriteToggle: () {
                  context.read<FavoriteCubit>().toggleFavorite(character);
                },
              );
            },
          );
        },
      ),
    );
  }
}
