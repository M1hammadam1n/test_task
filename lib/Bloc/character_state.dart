import 'package:test_task/domain/json.dart';

abstract class CharacterState {}

class CharacterInitial extends CharacterState {}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<RickMorty> characters;
  final bool hasMore;

  CharacterLoaded(this.characters, this.hasMore);
}

class CharacterError extends CharacterState {
  final String message;
  CharacterError(this.message);
}
