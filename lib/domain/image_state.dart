import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task/domain/json.dart';

Future<void> saveAllImages(List<Character> characters) async {
  final prefs = await SharedPreferences.getInstance();

  for (final character in characters) {
    final alreadySaved = prefs.containsKey('saved_image_${character.id}');
    if (alreadySaved) continue; // Пропускаем, если уже сохранено
// Проверяем, сохранено ли изображение для данного персонажа.
// Если сохранено, пропускаем его.  
    try {
      final response = await HttpClient().getUrl(Uri.parse(character.image));
      final imageBytes = await response.close().then(
        (res) => res.fold<List<int>>([], (p, e) => p..addAll(e)),
      );
      // Получаем байты изображения по URL персонажа.
      // Используем HttpClient для запроса изображения.
      // Закрываем соединение и собираем байты в список.
      // Преобразуем байты в строку base64 для сохранения.
      final base64Image = base64Encode(imageBytes);
      await prefs.setString('saved_image_${character.id}', base64Image);
    } catch (e) {
      print("Ошибка при сохранении image ${character.id}: $e");
    }
    // Если произошла ошибка при получении изображения, выводим сообщение об ошибке.
    // Используем try-catch для обработки возможных ошибок при запросе изображения. 
  }
}
