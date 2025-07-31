import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/Bloc/character_bloc.dart';
import 'package:test_task/Bloc/character_event.dart';
import 'package:test_task/Bloc/character_state.dart';
import 'package:test_task/Bloc/favorite_cubit.dart';
import 'package:test_task/components/card.dart';
import 'package:test_task/domain/json.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomePage({super.key, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterBloc>().add(LoadMoreCharacters());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карточки персонажей'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading && state is! CharacterLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            final characters = state.characters;
            final hasMore = state.hasMore;

            return BlocBuilder<FavoriteCubit, List<RickMorty>>(
              builder: (context, favorites) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: characters.length + (hasMore ? 1 : 0),
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    if (index == characters.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final character = characters[index];
                    final isFav = favorites.any((e) => e.id == character.id);

                    return CharacterCard(
                      character: character,
                      isFavorite: isFav,
                      onFavoriteToggle: () {
                        context.read<FavoriteCubit>().toggleFavorite(character);
                      },
                    );
                  },
                );
              },
            );
          } else if (state is CharacterError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
