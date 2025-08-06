import 'package:dio/dio.dart';
import 'package:test_task/domain/json.dart';

class ApiService {
  final Dio _dio = Dio();
  //Создает экземпляр Dio, который используется для HTTP-запросов.

  Future<List<Character>> fetchCharacter() async {
    //Асинхронная функция, возвращающая List<Character> — список объектов персонажей.
    try {
      final response = await _dio.get(
        "https://rickandmortyapi.com/api/character",
      );
      //Отправляется GET-запрос на api который возвращает JSON с данными о персонажах.
      final results = response.data['results'] as List;
      //Возьми поле results из JSON-ответа и приведи его к типу List
      return results.map((e) => Character.fromJson(e)).toList();
      //Для каждого элемента e в списке results (каждого JSON-персонажа), преобразуй его в объект Character с помощью fromJson, а потом собери все эти объекты в список и верни его»
    } catch (e) {
      throw Exception('errors failed');
      //Если запрос не удался то возвращает failed
    }
  }

  Future<Character> getCharacterById(int id) async {
    print('id for provider = ${id}');
    //Объявляется Future, который вернёт один объект Character.
    try {
      final response = await _dio.get(
        "https://rickandmortyapi.com/api/character/$id",
      );
      //Отправляется GET запрос на https://rickandmortyapi.com/api/character/1, 2, 3, и т.д. в зависимости от id.

      return Character.fromJson(response.data);
      //Данные (в формате JSON) передаются в твой конструктор Character.fromJson, который возвращает готовый объект.
    } catch (e) {
      throw Exception('Errors for id');
      //Если возникла ошибка (например, сервер недоступен или id не существует) — выбрасывается Exception.
    }
  }
}
