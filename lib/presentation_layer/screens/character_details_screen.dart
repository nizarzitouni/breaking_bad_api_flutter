import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic_layer/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data_layer/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailsScreen({required this.character, Key? key})
      : super(key: key);

  Widget buildSliverAppBAr() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        //centerTitle: true,
        title: Text(
          character.nickname,
          style: TextStyle(color: MyColors.myWhite),
          textAlign: TextAlign.start,
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: MyColors.myWhite,
              fontSize: 16,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDivider(double endIndentt) {
    return Divider(
      height: 30,
      color: MyColors.myYellow,
      endIndent: endIndentt,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state) {
    var quotes = (state).quotesCUBIT;
    if (quotes.length != 0) {
      int randomQoutesIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: MyColors.myWhite,
            shadows: const [
              Shadow(
                blurRadius: 7,
                color: MyColors.myYellow,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQoutesIndex].quote),
            ],
            repeatForever: true,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);

    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBAr(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Job : ', character.occupation.join(' / ')),
                      buildDivider(315),
                      characterInfo('Appeared in : ', character.category),
                      buildDivider(250),
                      characterInfo(
                          'Seasons : ', character.appearance.join(' / ')),
                      buildDivider(280),
                      characterInfo('Status : ', character.status),
                      buildDivider(300),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : characterInfo('Better Call Saul Seasons : ',
                              character.betterCallSaulAppearance.join(' / ')),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : buildDivider(150),
                      characterInfo('Actor/Actress : ', character.name),
                      buildDivider(235),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<CharactersCubit, CharactersState>(
                  builder: ((context, state) {
                    return checkIfQuotesAreLoded(state);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
