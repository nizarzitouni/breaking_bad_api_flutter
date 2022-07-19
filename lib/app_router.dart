import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic_layer/cubit/characters_cubit.dart';
import 'constants/strings.dart';
import 'data_layer/api/character_web_servises.dart';
import 'data_layer/models/character.dart';
import 'data_layer/repository/characters_repo.dart';
import 'presentation_layer/screens/character_details_screen.dart';
import 'presentation_layer/screens/characters_screen.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository =
        CharactersRepository(characterWebServises: CharacterWebServises());
    charactersCubit = CharactersCubit(charactersRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CharactersCubit(charactersRepository),
            child: CharactersScreen(),
          ),
        );

      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => CharactersCubit(charactersRepository),
                  child: CharacterDetailsScreen(character: character),
                ));
    }
  }
}
