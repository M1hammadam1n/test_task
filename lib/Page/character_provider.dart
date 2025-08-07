import 'package:flutter/material.dart';
import 'package:test_task/domain/api_service.dart';
import 'package:test_task/domain/json.dart';

enum Status { loading, success, errors }

class CardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Character> _characters = [];
  //_characters — список персонажей, полученных из API.
  Status _status = Status.loading;
  // _status — текущий статус загрузки (loading, success, errors).

  int _currentPage = 1;
  // Текущая страница пагинации
  bool hasMore = true;
  // Флаг, есть ли ещё данные для загрузки
  bool isLoadingMore = false;
  // Флаг, идёт ли сейчас подгрузка следующей страницы

  List<Character> get characters => _characters;
  //Даёт доступ к списку персонажей
  Status get status => _status;
  //Даёт доступ к текущему статусу загрузки
  //Возвращает приватную переменную

  Future<void> fetchCharacter() async {
    _status = Status.loading;
    //Устанавливает _status в loading, чтобы UI показал индикатор загрузки
    notifyListeners();
    //говорит всем слушателям (Consumer, Provider.of, Selector) → обновите UI!

    try {
      _currentPage = 1;
      // Сбрасываем счётчик страницы
      final newCharacters = await _apiService.fetchCharacter(_currentPage);
      // Вызывает метод API: fetchCharacter(page), который делает HTTP-запрос с номером страницы
      _characters = newCharacters;
      // Сохраняем полученные данные в список
      hasMore = newCharacters.isNotEmpty;
      // Если вернулось что-то — можно подгружать дальше
      _status = Status.success;
      // Меняет статус на success
    } catch (e) {
      _status = Status.errors;
      //Если произошла ошибка (например, нет интернета), то статус — errors
    }

    notifyListeners();
    //После получения данных (или ошибки), снова уведомляет UI — перерисовать экран
  }

  Future<void> fetchMoreCharacters() async {
    // Метод вызывается при достижении конца списка — подгружает новую страницу
    if (isLoadingMore || !hasMore) return;
    // Если уже загружается или больше нет данных — выходим
    isLoadingMore = true;
    _currentPage++;
    // Переходим к следующей странице

    try {
      final newCharacters = await _apiService.fetchCharacter(_currentPage);
      if (newCharacters.isEmpty) {
        hasMore = false;
        // Если больше персонажей нет — флаг в false
      } else {
        _characters.addAll(newCharacters);
        // Добавляем новые персонажи к уже загруженным
      }
    } catch (e) {
      // При ошибке — просто не загружаем ничего
      hasMore = false;
    }

    isLoadingMore = false;
    notifyListeners();
    // Обновляем UI
  }
}

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favorites = [];
  // Список избранных персонажей по их ID.

  List<int> get favorites => _favorites;
  // Возвращает список избранных персонажей.

  void toggleFavorite(int id) {
    // Переключает состояние избранного для персонажа с данным id.
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }
  // Уведомляет слушателей об изменении списка избранных персонажей.
  // Если id уже есть в списке, удаляет его, иначе добавляет.

  bool isFavorite(int id) => _favorites.contains(id);
  // Проверяет, есть ли id в списке избранных персонажей.
  // Возвращает true, если есть, иначе false.
}
