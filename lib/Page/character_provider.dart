import 'package:flutter/material.dart';
import 'package:test_task/domain/api_service.dart';
import 'package:test_task/domain/json.dart';

enum Status { loading, success, errors }

class CardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Character> _characters = [];
  Status _status = Status.loading;

  List<Character> get characters => _characters;
  Status get status => _status;

  Future<void> fetchCharacter() async {
    _status = Status.loading;
    notifyListeners();
    try {
      _characters = await _apiService.fetchCharacter();
      _status = Status.success;
    } catch (e) {
      _status = Status.errors;
    }
    notifyListeners();
  }
}
