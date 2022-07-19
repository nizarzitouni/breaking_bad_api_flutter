import 'package:breaking_bad_api_app/data_layer/models/quotes.dart';

import '../api/character_web_servises.dart';
import '../models/character.dart';

class CharactersRepository {
  final CharacterWebServises characterWebServises;
  CharactersRepository({
    required this.characterWebServises,
  });

  Future<List<Character>> getAllCharacters() async {
    //characters<== response.data
    final List characters = await characterWebServises.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getAllCharacterQuotes(String charName) async {
    //quotes<== response.data
    final List quotes =
        await characterWebServises.getAllCharacterQuotes(charName);
    return quotes.map((charQuotes) => Quote.fromJson(charQuotes)).toList();
  }
}
