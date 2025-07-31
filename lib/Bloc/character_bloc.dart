import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/Bloc/character_event.dart';
import 'package:test_task/Bloc/character_state.dart';
import 'package:test_task/domain/api_client.dart';
import 'package:test_task/domain/json.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  int _currentPage = 1;
  bool _hasMore = true;
  List<RickMorty> _characters = [];

  CharacterBloc() : super(CharacterInitial()) {
    on<LoadCharacters>(_onLoad);
    on<LoadMoreCharacters>(_onLoadMore);
  }

  Future<void> _onLoad(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      _currentPage = 1;
      _hasMore = true;
      _characters.clear();

      final characters = await getCharactersPage(_currentPage);
      _characters.addAll(characters);
      _currentPage++;
      _hasMore = characters.isNotEmpty;

      emit(CharacterLoaded(List.from(_characters), _hasMore));
    } catch (e) {
      emit(CharacterError('Ошибка: $e'));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (!_hasMore || state is CharacterLoading) return;

    try {
      final characters = await getCharactersPage(_currentPage);
      _characters.addAll(characters);
      _hasMore = characters.isNotEmpty;
      _currentPage++;

      emit(CharacterLoaded(List.from(_characters), _hasMore));
    } catch (e) {
      emit(CharacterError('Ошибка при догрузке: $e'));
    }
  }
}
