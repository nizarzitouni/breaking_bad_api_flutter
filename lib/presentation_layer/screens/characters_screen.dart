// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_offline/flutter_offline.dart';

import '../../business_logic_layer/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data_layer/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allCharacters = [];
  List<Character> searchedForCharacters = [];
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //Ui asking from bloc=> give me data 'State'
    //bloc wake the lazy cuibit and tell him UI asks for you
    //cuibit gets data from repository 'his constractor'
    //repository gets data from webservices 'his constractor'
    //webservices gets data from dio from server
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: ((context, state) {
        if (state is CharactersLoaded) {
          allCharacters =
              (state).charactersCUBIT; // CharactersLoaded list of chars
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      }),
    );
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(color: MyColors.myYellow),
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _searchTextController.text.isEmpty
            ? allCharacters.length
            : searchedForCharacters.length,
        itemBuilder: (ctx, index) {
          return CharacterItem(
            character: _searchTextController.text.isEmpty
                ? allCharacters[index]
                : searchedForCharacters[index],
          );
        });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Fint A Character ...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedChar) {
        addSearchedForItemsToSearchedList(searchedChar);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedChar) {
    searchedForCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedChar))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: MyColors.myGrey,
          ),
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearching,
          icon: Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        )
      ];
    }
  }

  void _startSearching() {
    //create a small new screen for searching
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    _searchTextController.clear();
  }

  Widget _buildAppBarTitile() {
    return Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  Widget buildNonInternetWidget() {
    return Center(
        child: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Can\'t Connect .. check your internet',
            style: TextStyle(
              fontSize: 22,
              color: MyColors.myGrey,
            ),
          ),
          Image.asset('assets/images/undraw_Questions.png'),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitile(),
        actions: _buildAppBarActions(),
        leading:
            _isSearching ? BackButton(color: MyColors.myGrey) : Container(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;

          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNonInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
}
