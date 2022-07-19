part of 'characters_cubit.dart';

@immutable
abstract class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> charactersCUBIT;

  CharactersLoaded(this.charactersCUBIT);
}

class QuotesLoaded extends CharactersState {
  final List<Quote> quotesCUBIT;

  QuotesLoaded(this.quotesCUBIT);
}
