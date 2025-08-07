import 'package:dio/dio.dart';
import 'package:test_task/domain/json.dart';

class ApiService {
  final Dio _dio = Dio();
  //Создает экземпляр Dio, который используется для HTTP-запросов.
  Future<List<Character>> fetchCharacter(int currentPage) async {
    //Асинхронная функция, возвращающая List<Character> — список объектов персонажей.
    try {
      final response = await _dio.get(
        "https://rickandmortyapi.com/api/character",
        queryParameters: {
          'page': currentPage, // добавляем параметр page в запрос
        },
        //Отправляет GET-запрос на API Rick and Morty с параметром page.
        options: Options(
          headers: {
            'Accept': 'application/json',
            //Устанавливает заголовок Accept для указания, что ожидается JSON-ответ
          },
        ),
      );
      //Отправляется GET-запрос на https://rickandmortyapi.com/api/character?page=1 и т.д.

      final results = response.data['results'] as List;
      //Извлекаем список персонажей из JSON-поля "results"

      return results.map((e) => Character.fromJson(e)).toList();
      //Преобразуем каждый JSON-объект в экземпляр класса Character и возвращаем список
    } catch (e) {
      throw Exception('errors failed');
      //Если запрос не удался — выбрасываем исключение
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
