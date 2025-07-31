import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/domain/json.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteCubit extends Cubit<List<RickMorty>> {
  FavoriteCubit() : super([]);

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    final items = favs.map((e) => RickMorty.fromJson(json.decode(e))).toList();
    emit(items);
  }

  void toggleFavorite(RickMorty character) async {
    final current = List<RickMorty>.from(state);
    final exists = current.any((e) => e.id == character.id);
    if (exists) {
      current.removeWhere((e) => e.id == character.id);
    } else {
      current.add(character);
    }
    final prefs = await SharedPreferences.getInstance();
    final encoded = current.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('favorites', encoded);
    emit(current);
  }
}
