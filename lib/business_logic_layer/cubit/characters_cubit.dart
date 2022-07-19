import 'package:bloc/bloc.dart';
import 'package:breaking_bad_api_app/data_layer/models/quotes.dart';
import '../../data_layer/models/character.dart';
import '../../data_layer/repository/characters_repo.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  final CharactersRepository charactersRepository;
  List<Character> characters = [];
  List<Quote> quotes = [];

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotes(String charName) {
    charactersRepository.getAllCharacterQuotes(charName).then((quotes) {
      emit(QuotesLoaded(quotes));
    });
  }
}
