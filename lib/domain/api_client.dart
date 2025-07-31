import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_task/domain/json.dart';

Future<List<RickMorty>> getCharactersPage(int page) async {
  final url = Uri.parse('https://rickandmortyapi.com/api/character?page=$page');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final results = data['results'] as List;
    return results.map((e) => RickMorty.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load characters');
  }
}
