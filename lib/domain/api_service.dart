import 'package:dio/dio.dart';
import 'package:test_task/domain/json.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Character>> fetchCharacter() async {
    try {
      final response = await _dio.get(
        "https://rickandmortyapi.com/api/character",
      );
      final results = response.data['results'] as List;
      return results.map((e) => Character.fromJson(e)).toList();
    } catch (e) {
      throw Exception('errors failed');
    }
  }
}