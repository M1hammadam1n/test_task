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

  List<Character> get characters => _characters;
  //Даёт доступ к списку персонажей
  Status get status => _status;
  //Даёт доступ к текущему статусу загрузки
  //Возвращает приватную переменную

  Future<void> fetchCharacter() async {
    _status = Status.loading;
    //Устанавливает _status в loading, чтобы UI показал индикатор загрузки
    notifyListeners();
    // говорит всем слушателям (Consumer, Provider.of, Selector) → обновите UI!
    try {
      _characters = await _apiService.fetchCharacter();
      _status = Status.success;
      //       Вызывает метод API: fetchCharacter(), который делает HTTP-запрос.

      // Сохраняет полученные данные в _characters.

      // Меняет статус на success.
    } catch (e) {
      _status = Status.errors;
      //Если произошла ошибка (например, нет интернета), то статус — errors.
    }
    notifyListeners();
    //После получения данных (или ошибки), снова уведомляет UI — перерисовать экран.
  }
}

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favorites = [];

  List<int> get favorites => _favorites;

  void toggleFavorite(int id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.contains(id);
}
